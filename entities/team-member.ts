import {
  Entity,
  Column,
  Index,
  JoinColumn,
  OneToOne,
  ManyToMany,
  OneToMany,
  ManyToOne,
} from 'typeorm';
import Model from './base.entity';
import { User } from './user.entity';
import { Task } from './task.entity';
import { Project } from './project.entity';
import { TimeLog } from './time-log.entity';
import { GithubLink } from './user-link.entity';
import { AuditLog } from './audit.entity';
import { Comment } from './comment.entity';

@Entity('team_members')
@Index(['id'], { unique: true })
export class TeamMember extends Model {
  @Column({ name: 'joinin_date', nullable: true })
  joiningDate?: Date;

  @Column({ name: 'monthly_salary', nullable: true })
  monthlySalary?: number;

  @Column({ name: 'department', nullable: true })
  department?: string;

  @Column({ name: 'designation', nullable: true })
  designation?: string;

  @Column({ type: 'json', name: 'skills', nullable: true })
  skills?: unknown[];

  @Column({ name: 'experience', nullable: true })
  experience?: string;

  @Column({ name: 'user_id', nullable: true })
  userId?: number;

  @Column({ name: 'created_by_id', nullable: true })
  createdById?: number;

  // created by relationship
  @ManyToOne(() => User)
  @JoinColumn({ name: 'created_by_id' })
  createdBy: User;

  // Joins
  @OneToOne(() => User, (user) => user.teamMember, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @ManyToMany(() => Project, (project) => project.assignees, {
    onDelete: 'CASCADE',
  })
  projects: Project[];

  @ManyToMany(() => Task, (task) => task.assignees, { onDelete: 'CASCADE' })
  tasks: Task[];

  @OneToMany(() => TimeLog, (timeLog) => timeLog.teamMember)
  timeLogs: TimeLog[];

  @OneToMany(() => GithubLink, (githubLink) => githubLink.teamMember)
  githubLinks: GithubLink[];

  @OneToMany(() => Comment, (comment) => comment.author)
  comments: Comment[];

  @OneToMany(() => AuditLog, (auditLog) => auditLog.teamMember)
  auditLogs: AuditLog[];
}
