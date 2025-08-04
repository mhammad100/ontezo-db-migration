import { Entity, Column, ManyToOne, JoinColumn, Index } from 'typeorm';
import Model from './base.entity';
import { Task } from './task.entity';

@Entity('use_cases')
@Index(['id', 'title'])
export class UseCase extends Model {
  @Column()
  title: string;

  @Column({ nullable: true })
  description: string;

  @Column({ default: false })
  isChecked: boolean;

  @Column({ name: 'task_id' })
  taskId: number;

  @ManyToOne(() => Task, (task) => task.useCases, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'task_id' })
  task: Task;
}
