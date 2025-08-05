import {
  Entity,
  Column,
  OneToMany,
  ManyToMany,
  ManyToOne,
  JoinTable,
  Index,
  JoinColumn,
} from 'typeorm';
import { Task } from '../entities/task.entity';
import Model from './base.entity';
import { TeamMember } from './team-member';
import { ProjectStatus } from './project-status.entity';
import { Client } from './client.entity';
import { Phase } from './phase.entity';
import { Comment } from './comment.entity';
import { User } from './user.entity';
import { Sprint } from './sprint.entity';
import { MediaRecord } from './media-record.entity';
import { ProjectDuration } from '../common/enums/projects.enum';
import { AuditLog } from './audit.entity';
@Entity('projects')
@Index(['id', 'name', 'slug'])
export class Project extends Model {
  @Column()
  name: string;

  @Column({ unique: true })
  slug: string;

  @Column({ nullable: true })
  description: string;

  @Column({ default: 'active' })
  status: string;

  @Column({
    name: 'project_duration',
    type: 'enum',
    enum: ProjectDuration,
    enumName: 'project_duration_enum',
    nullable: true,
    default: null,
  })
  projectDuration: ProjectDuration;

  @Column({ name: 'is_sprint_project', default: false })
  isSprintProject: boolean;

  @Column({ nullable: true })
  clientId: string;

  @Column({
    name: 'start_date',
    type: 'date',
    nullable: true,
    default: new Date(),
  })
  startDate: Date;

  @Column({ type: 'json', nullable: true })
  documents: Record<string, any>[];

  @Column({ name: 'end_date', type: 'date', nullable: true })
  endDate: Date;

  @Column({ name: 'created_by_id', nullable: true })
  createdById?: number;

  @ManyToOne(() => User)
  @JoinColumn({ name: 'created_by_id' })
  createdBy: User;

  @ManyToOne(() => Client, (client) => client.projects, {
    onDelete: 'CASCADE',
  })
  client: Client;

  @OneToMany(() => Task, (task) => task.project, { cascade: true })
  tasks: Task[];

  @OneToMany(() => ProjectStatus, (status) => status.project, {
    cascade: true,
  })
  statuses: ProjectStatus[];

  @OneToMany(() => Phase, (phase) => phase.project, {
    cascade: true,
  })
  phases: Phase[];

  @OneToMany(() => Sprint, (sprint) => sprint.project, {
    cascade: true,
  })
  sprints: Sprint[];

  @OneToMany(() => Comment, (comment) => comment.project, { cascade: true })
  comments: Comment[];

  @ManyToMany(() => TeamMember, { onDelete: 'CASCADE' })
  @JoinTable({
    name: 'project_assignees',
    joinColumn: {
      name: 'project_id',
      referencedColumnName: 'id',
    },
    inverseJoinColumn: {
      name: 'team_member_id',
      referencedColumnName: 'id',
    },
  })
  assignees: TeamMember[];

  @OneToMany(() => MediaRecord, (mediaRecord) => mediaRecord.project, {
    onDelete: 'CASCADE',
  })
  mediaRecords: MediaRecord[];

  @OneToMany(() => AuditLog, (auditLog) => auditLog.project, { cascade: true })
  auditLogs: AuditLog[];
}
