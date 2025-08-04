import { Entity, Column, ManyToOne } from 'typeorm';
import { User } from './user.entity';
import { Preferences } from '@/common/enums/prefrences.enum';
import Model from './base.entity';

@Entity('user_preferences')
export class UserPreference extends Model {
  @Column({ type: 'enum', enum: Preferences, nullable: false })
  category: (typeof Preferences)[keyof typeof Preferences];

  @Column('simple-array', { nullable: true })
  value: string[]; // Array of selected options e.g. ['Work', 'Operations', 'CRM']

  @Column({ name: 'user_id', nullable: false })
  userId: number;

  @ManyToOne(() => User, (user) => user.preferences, { onDelete: 'CASCADE' })
  user: User;
}
