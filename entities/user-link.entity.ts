import { Entity, Column, ManyToOne, JoinColumn, Index } from 'typeorm';
import Model from './base.entity';
import { Task } from './task.entity';
import { TeamMember } from './team-member';
import { Platform } from '../common/enums/platform.enum';

@Entity('user_links')
@Index(['id', 'taskId', 'teamMemberId'])
export class GithubLink extends Model {
  @Column()
  url: string;

  @Column({ nullable: true })
  description?: string;

  @Column({ name: 'type', nullable: true })
  type?: string; // PR, commit, issue, etc.

  @Column({ type: 'enum', enum: Platform, default: Platform.GITHUB })
  platform: Platform;

  @Column({ name: 'task_id' })
  taskId: number;

  @Column({ name: 'team_member_id' })
  teamMemberId: number;

  @ManyToOne(() => Task, (task) => task.githubLinks, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'task_id' })
  task: Task;

  @ManyToOne(() => TeamMember, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'team_member_id' })
  teamMember: TeamMember;
}
