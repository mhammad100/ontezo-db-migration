import { Entity, Column, ManyToOne, JoinColumn, Index } from 'typeorm';
import Model from './base.entity';
import { Task } from './task.entity';

@Entity('test_cases')
@Index(['id', 'title'])
export class TestCase extends Model {
  @Column()
  title: string;

  @Column({ nullable: true })
  description: string;

  @Column({ default: false })
  isChecked: boolean;

  @Column({ nullable: true })
  steps: string;

  @Column({ nullable: true, name: 'expected_result' })
  expectedResult: string;

  @Column({ nullable: true, name: 'actual_result' })
  actualResult: string;

  @Column({ name: 'task_id' })
  taskId: number;

  @ManyToOne(() => Task, (task) => task.testCases, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'task_id' })
  task: Task;
}
