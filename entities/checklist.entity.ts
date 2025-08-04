import { Entity, Column, ManyToOne, OneToMany, JoinColumn } from 'typeorm';
import { Phase } from './phase.entity';
import Model from './base.entity';
import { ChecklistItem } from './checklist-item.entity';

@Entity('checklists')
export class Checklist extends Model {
  @Column()
  name: string;

  @Column({ default: 'active' })
  status: string;

  @Column({ name: 'phase_id', nullable: true })
  phaseId: number;

  @ManyToOne(() => Phase, (phase) => phase.checklists, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'phase_id' })
  phase: Phase;

  @OneToMany(() => ChecklistItem, (item) => item.checklist, {
    cascade: true,
  })
  items: ChecklistItem[];
}
