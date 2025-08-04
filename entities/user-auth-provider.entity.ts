import { Entity, Column, ManyToOne } from 'typeorm';
import { User } from './user.entity';
import Model from './base.entity';

@Entity('user_auth_providers')
export class UserAuthProvider extends Model {
  @Column()
  provider: string; // 'google', 'facebook', 'apple'

  @Column()
  socialId: string;

  @ManyToOne(() => User, (user) => user.authProviders)
  user: User;
}
