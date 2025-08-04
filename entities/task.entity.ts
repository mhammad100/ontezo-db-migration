import {
  Entity,
  Column,
  ManyToOne,
  JoinColumn,
  ManyToMany,
  JoinTable,
  Index,
  OneToMany,
} from 'typeorm';
import { Project } from '../entities/project.entity';
import Model from './base.entity';
import { TeamMember } from './team-member';
import { UseCase } from './use-case.entity';
import { TestCase } from './test-case.entity';
import { TimeLog } from './time-log.entity';
import { GithubLink } from './user-link.entity';
import { Comment } from './comment.entity';
import { User } from './user.entity';
import { Sprint } from './sprint.entity';
import { MediaRecord } from './media-record.entity';
import { AuditLog } from './audit.entity';
import { ProjectStatus } from './project-status.entity';
import { SprintStatus } from './sprint-status.entity';

@Entity('tasks')
@Index(['id', 'title', 'projectId', 'slug'])
export class Task extends Model {
  @Column()
  title: string;

  @Column({ unique: true })
  slug: string;

  @Column({ nullable: true })
  description: string;

  @Column({ default: 'pending' })
  status: string;

  @Column({ name: 'start_date', type: 'date', default: new Date() })
  startDate: Date;

  @Column({ name: 'due_date', type: 'date', nullable: true })
  dueDate: Date;

  @Column({ nullable: true, default: 'low' })
  priority: string;

  @Column({ type: 'json', nullable: true })
  tags: string[];

  @Column({ name: 'project_id' })
  projectId: number;

  @Column({ name: 'sprint_id', nullable: true })
  sprintId: number;

  @Column({ name: 'parent_task_id', nullable: true })
  parentTaskId?: number;

  @Column({
    name: 'story_point',
    type: 'decimal',
    precision: 4,
    scale: 1,
    default: '0.0',
  })
  storyPoint: string;

  @Column({ name: 'created_by_id', nullable: true })
  createdById?: number;

  // created by relationship
  @ManyToOne(() => User)
  @JoinColumn({ name: 'created_by_id' })
  createdBy: User;

  @ManyToOne(() => Project, (project) => project.tasks, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'project_id' })
  project: Project;

  @ManyToOne(() => Sprint, (sprint) => sprint.tasks, {
    onDelete: 'SET NULL',
  })
  @JoinColumn({ name: 'sprint_id' })
  sprint: Sprint;

  @ManyToOne(() => Task, (task) => task.subtasks, {
    nullable: true,
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'parent_task_id' })
  parentTask?: Task;

  @OneToMany(() => Task, (task) => task.parentTask, {
    cascade: true,
    onDelete: 'CASCADE',
  })
  subtasks: Task[];

  @OneToMany(() => UseCase, (useCase) => useCase.task, { cascade: true })
  useCases: UseCase[];

  @OneToMany(() => TestCase, (testCase) => testCase.task, { cascade: true })
  testCases: TestCase[];

  @OneToMany(() => Comment, (comment) => comment.task, { cascade: true })
  comments: Comment[];

  @OneToMany(() => TimeLog, (timeLog) => timeLog.task, { cascade: true })
  timeLogs: TimeLog[];

  @OneToMany(() => GithubLink, (githubLink) => githubLink.task, {
    cascade: true,
  })
  githubLinks: GithubLink[];

  @ManyToMany(() => TeamMember, { onDelete: 'CASCADE' })
  @JoinTable({
    name: 'task_assignees',
    joinColumn: {
      name: 'task_id',
      referencedColumnName: 'id',
    },
    inverseJoinColumn: {
      name: 'team_member_id',
      referencedColumnName: 'id',
    },
  })
  assignees: TeamMember[];

  @OneToMany(() => MediaRecord, (mediaRecord) => mediaRecord.task, {
    onDelete: 'CASCADE',
  })
  mediaRecords: MediaRecord[];

  @OneToMany(() => AuditLog, (auditLog) => auditLog.task, { cascade: true })
  auditLogs: AuditLog[];

  @ManyToOne(() => SprintStatus, (status) => status.tasks, {
    onDelete: 'SET NULL',
    nullable: true,
  })
  @JoinColumn({ name: 'sprint_status_id' })
  sprintStatus: SprintStatus;

  @ManyToOne(() => ProjectStatus, (status) => status.tasks, {
    onDelete: 'SET NULL',
    nullable: true,
  })
  @JoinColumn({ name: 'project_status_id' })
  projectStatus: ProjectStatus;
}
