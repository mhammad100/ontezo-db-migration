CREATE TABLE IF NOT EXISTS role_permissions (
    id SERIAL PRIMARY KEY,
    role_id INTEGER NOT NULL,
    permission_id INTEGER NOT NULL,
    is_global BOOLEAN DEFAULT FALSE,
    UNIQUE(role_id, permission_id)
);


SET session_replication_role = replica;




-- Migrating RolePermissions to role_permissions
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('1', '9', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('1', '10', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('1', '11', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('1', '12', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('2', '5', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('2', '6', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('2', '7', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('2', '8', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('2', '9', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('2', '10', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('2', '11', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('2', '12', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('2', '13', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('2', '14', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('2', '15', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('2', '25', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('2', '27', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('3', '9', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('3', '10', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('3', '11', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('3', '12', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('3', '14', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('3', '27', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('3', '28', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('4', '1', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('4', '2', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('4', '3', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('4', '4', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('5', '5', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('5', '6', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('5', '7', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('5', '8', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('5', '9', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('5', '10', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('5', '11', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('5', '12', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('5', '13', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('5', '14', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('5', '15', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('5', '25', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('5', '27', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('5', '29', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '1', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '2', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '3', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '4', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '5', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '6', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '7', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '8', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '9', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '10', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '11', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '12', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '13', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '14', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '15', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '21', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '22', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '23', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '24', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '25', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '27', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '28', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('6', '29', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('7', '5', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('7', '6', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('7', '7', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('7', '8', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('7', '9', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('7', '10', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('7', '11', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('7', '12', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('7', '13', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('7', '25', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('7', '27', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('9', '5', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('9', '6', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('9', '7', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('9', '8', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('9', '9', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('9', '10', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('9', '11', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('9', '12', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('9', '13', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('9', '25', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('9', '27', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('10', '5', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('10', '6', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('10', '8', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('10', '13', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('10', '14', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('10', '25', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('10', '29', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('11', '9', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('11', '10', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('11', '11', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('11', '12', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('11', '27', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('12', '13', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('12', '14', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('12', '15', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('12', '28', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('12', '29', true);
INSERT INTO role_permissions (role_id, permission_id, is_global) VALUES ('12', '32', true);