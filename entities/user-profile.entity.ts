import { Entity, Column, OneToOne, JoinColumn } from 'typeorm';
import Model from './base.entity';
import { User } from './user.entity';

@Entity('user_profiles')
export class UserProfile extends Model {
  @Column({ name: 'full_name', nullable: true })
  fullName: string;

  @Column({ nullable: true })
  phone: string;

  @Column({ name: 'date_of_birth', type: 'date', nullable: true })
  dateOfBirth: Date;

  @Column({ nullable: true })
  address: string;

  @Column({ nullable: true })
  city: string;

  @Column({ nullable: true })
  state: string;

  @Column({ name: 'postal_code', nullable: true })
  postalCode: string;

  @Column({ nullable: true })
  country: string;

  @Column({ name: 'profile_picture', nullable: true })
  profilePicture: string;

  @Column({ name: 'is_profile_complete', type: 'boolean', default: false })
  isProfileComplete: boolean;

  @Column({ name: 'user_id', nullable: false })
  userId: number;

  @OneToOne(() => User, (user) => user.profile, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: User;
}
