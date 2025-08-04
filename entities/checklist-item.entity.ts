import { Entity, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Checklist } from './checklist.entity';
import Model from './base.entity';

@Entity('checklist_items')
export class ChecklistItem extends Model {
  @Column()
  description: string;

  @Column({ name: 'is_checked', default: false })
  isChecked: boolean;

  @Column({ name: 'checklist_id', nullable: true })
  checklistId: number;

  @ManyToOne(() => Checklist, (checklist) => checklist.items, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'checklist_id' })
  checklist: Checklist;
}
