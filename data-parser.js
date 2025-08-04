const fs = require('fs');

class DataParser {
    constructor() {
        this.data = {};
    }

    // Parse the large data file in chunks
    parseDataFile(filePath) {
        console.log('Parsing data file in chunks...');
        
        const stream = fs.createReadStream(filePath, { encoding: 'utf8' });
        let buffer = '';
        let currentTable = null;
        let currentValues = [];
        
        return new Promise((resolve, reject) => {
            stream.on('data', (chunk) => {
                buffer += chunk;
                
                // Process complete INSERT statements
                const insertMatches = buffer.match(/INSERT INTO `([^`]+)` VALUES\s*([^;]+);/g);
                if (insertMatches) {
                    insertMatches.forEach(match => {
                        const tableName = match.match(/INSERT INTO `([^`]+)`/)[1];
                        const values = match.match(/VALUES\s*([^;]+)/)[1];
                        
                        if (!this.data[tableName]) {
                            this.data[tableName] = [];
                        }
                        
                        const rows = this.parseInsertValues(values);
                        this.data[tableName].push(...rows);
                    });
                    
                    // Remove processed matches from buffer
                    buffer = buffer.replace(/INSERT INTO `[^`]+` VALUES\s*[^;]+;/g, '');
                }
            });
            
            stream.on('end', () => {
                console.log(`Parsed data for ${Object.keys(this.data).length} tables`);
                resolve(this.data);
            });
            
            stream.on('error', (error) => {
                reject(error);
            });
        });
    }

    // Parse INSERT VALUES with better handling of complex data
    parseInsertValues(values) {
        const rows = [];
        const valueGroups = values.match(/\(([^)]+)\)/g);
        
        if (!valueGroups) return rows;
        
        valueGroups.forEach(group => {
            const cleanGroup = group.replace(/[()]/g, '');
            const values = this.splitValues(cleanGroup);
            rows.push(values);
        });
        
        return rows;
    }

    // Split values while respecting quoted strings
    splitValues(valueString) {
        const values = [];
        let current = '';
        let inQuotes = false;
        let quoteChar = null;
        
        for (let i = 0; i < valueString.length; i++) {
            const char = valueString[i];
            
            if ((char === "'" || char === '"') && !inQuotes) {
                inQuotes = true;
                quoteChar = char;
                current += char;
            } else if (char === quoteChar && inQuotes) {
                inQuotes = false;
                quoteChar = null;
                current += char;
            } else if (char === ',' && !inQuotes) {
                values.push(current.trim());
                current = '';
            } else {
                current += char;
            }
        }
        
        if (current.trim()) {
            values.push(current.trim());
        }
        
        return values;
    }

    // Get parsed data
    getData() {
        return this.data;
    }
}

module.exports = DataParser; 