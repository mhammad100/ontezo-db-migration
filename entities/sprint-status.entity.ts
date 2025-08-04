import {
  Entity,
  Column,
  ManyToOne,
  JoinColumn,
  Index,
  OneToMany,
} from 'typeorm';
import Model from './base.entity';
import { Sprint } from './sprint.entity';
import { Task } from './task.entity';

@Entity('sprint_statuses')
@Index(['id', 'name', 'sprintId'])
export class SprintStatus extends Model {
  @Column()
  display_name: string;

  @Column()
  name: string;

  @Column()
  order: number;

  @Column({ name: 'sprint_id' })
  sprintId: number;

  @ManyToOne(() => Sprint, (sprint) => sprint.statuses, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'sprint_id' })
  sprint: Sprint;

  @OneToMany(() => Task, (task) => task.status, { cascade: true })
  tasks: Task[];
}
