import {
  Entity,
  Column,
  Index,
  ManyToOne,
  JoinColumn,
  OneToMany,
} from 'typeorm';
import Model from './base.entity';
import { MediaType, Tag } from '@/common/enums/media.enum';
import { User } from './user.entity';
import { MediaRecord } from './media-record.entity';

@Entity('media')
@Index('idx_media_file_name', ['fileName'])
export class Media extends Model {
  @Column({ name: 'file_name', nullable: true })
  fileName: string;

  @Column({ name: 'original_name', nullable: true })
  originalName: string;

  @Column({ name: 'mime_type', nullable: true })
  mimeType: string;

  @Column({ nullable: true })
  size: number;

  @Column({ nullable: true })
  url: string;

  @Column({
    type: 'enum',
    enum: MediaType,
    default: MediaType.OTHER,
  })
  type: MediaType;

  @Column({
    type: 'enum',
    enum: Tag,
    default: Tag.USER,
  })
  tag: Tag;

  @Column({ nullable: true })
  description: string;

  @Column()
  bucket: string;

  @Column()
  key: string;

  @Column({ nullable: true })
  thumbnail: string;

  @Column({ name: 'created_by_id', nullable: true })
  createdById?: number;

  @ManyToOne(() => User)
  @JoinColumn({ name: 'created_by_id' })
  createdBy: User;

  @OneToMany(() => MediaRecord, (mediaRecord) => mediaRecord.media, {
    onDelete: 'CASCADE',
  })
  mediaRecords: MediaRecord[];
}
