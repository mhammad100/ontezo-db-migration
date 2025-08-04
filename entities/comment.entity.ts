import {
  Entity,
  Column,
  ManyToOne,
  JoinColumn,
  Index,
  OneToMany,
} from 'typeorm';
import Model from './base.entity';
import { Task } from './task.entity';
import { Project } from './project.entity';
import { TeamMember } from './team-member';
import { Tag } from '@/common/enums/comment.enum';

@Entity('comments')
@Index('idx_comment_content', ['content'])
@Index('idx_comment_parent_comment_id', ['parentCommentId'])
@Index('idx_comment_team_member_id', ['teamMemberId'])
@Index('idx_comment_project_id', ['projectId'])
@Index('idx_comment_task_id', ['taskId'])
export class Comment extends Model {
  @Column()
  content: string;

  @Column({ name: 'attachment', type: 'json', nullable: true })
  attachment: string | Array<any>;

  @Column({ name: 'parent_comment_id', nullable: true })
  parentCommentId?: number;

  @Column({ name: 'team_member_id' })
  teamMemberId: number;

  @Column({ name: 'project_id', nullable: true })
  projectId?: number;

  @Column({ name: 'task_id', nullable: true })
  taskId?: number;

  @Column({ type: 'enum', enum: Tag, nullable: true, default: Tag.PROJECT })
  tag?: Tag;

  @Column({ name: 'is_edited', type: 'boolean', default: false })
  isEdited: boolean;

  @ManyToOne(() => Project, (project) => project.comments, {
    nullable: true,
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'project_id' })
  project?: Project;

  @ManyToOne(() => Task, (task) => task.comments, {
    nullable: true,
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'task_id' })
  task?: Task;

  @ManyToOne(() => TeamMember)
  @JoinColumn({ name: 'team_member_id' })
  author: TeamMember;

  @ManyToOne(() => Comment, (comment) => comment.replies, {
    nullable: true,
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'parent_comment_id' })
  parentComment?: Comment;

  @OneToMany(() => Comment, (comment) => comment.parentComment)
  replies: Comment[];
}
