import { Entity, Column, ManyToOne, JoinColumn, Index } from 'typeorm';
import Model from './base.entity';
import { Media } from './media.entity';
import { User } from './user.entity';
import { Project } from './project.entity';
import { Task } from './task.entity';
import { Comment } from './comment.entity';

@Entity('media_records')
@Index('idx_media_record_relations', ['userId', 'projectId', 'taskId'])
export class MediaRecord extends Model {
  @Column({ name: 'media_id' })
  mediaId: number;

  @Column({ name: 'user_id', nullable: true })
  userId: number;

  @Column({ name: 'project_id', nullable: true })
  projectId: number;

  @Column({ name: 'task_id', nullable: true })
  taskId: number;

  @Column({ name: 'comment_id', nullable: true })
  commentId: number;

  @ManyToOne(() => Media, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'media_id' })
  media: Media;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @ManyToOne(() => Project, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'project_id' })
  project: Project;

  @ManyToOne(() => Task, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'task_id' })
  task: Task;

  @ManyToOne(() => Comment, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'comment_id' })
  comment: Comment;
}
