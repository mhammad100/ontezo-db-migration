import { Entity, Column, ManyToOne, JoinColumn, Index } from 'typeorm';
import Model from './base.entity';
import { Task } from './task.entity';
import { TeamMember } from './team-member';

@Entity('time_logs')
@Index(['id', 'taskId', 'teamMemberId'])
export class TimeLog extends Model {
  @Column({ name: 'start_time', type: 'timestamp' })
  startTime: Date;

  @Column({ name: 'end_time', type: 'timestamp', nullable: true })
  endTime?: Date;

  @Column({ type: 'float', nullable: true })
  hours?: number;

  @Column({ nullable: true })
  description?: string;

  @Column({ name: 'task_id' })
  taskId: number;

  @Column({ name: 'team_member_id' })
  teamMemberId: number;

  @ManyToOne(() => Task, (task) => task.timeLogs, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'task_id' })
  task: Task;

  @ManyToOne(() => TeamMember, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'team_member_id' })
  teamMember: TeamMember;
}
