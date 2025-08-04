import { Helper } from '@/utils';
import {
  Entity,
  Column,
  BeforeInsert,
  ManyToMany,
  JoinTable,
  Index,
  ManyToOne,
  JoinColumn,
  OneToMany,
  OneToOne,
} from 'typeorm';
import Model from './base.entity';
import { Role } from './role.entity';
import { Tenant } from './tenant.entity';
import { TeamMember } from './team-member';
import { UserProfile } from './user-profile.entity';
import { UserAuthProvider } from './user-auth-provider.entity';
import { UserPreference } from './user-preference.entity';
import { MediaRecord } from './media-record.entity';

@Entity('users')
@Index(['id', 'email'], { unique: true })
export class User extends Model {
  @Column({ unique: true })
  email: string;

  @Column()
  password: string;

  @Column({ name: 'otp_code', nullable: true })
  otpCode?: string;

  @Column({ name: 'timezone', nullable: true })
  timezone?: string;

  @Column({ name: 'is_email_verified', type: 'boolean', default: false })
  isEmailVerified: boolean;

  @Column({ name: 'is_password_forget', type: 'boolean', default: false })
  isPasswordForget: boolean;

  @Column({ name: 'last_login', type: 'timestamptz', nullable: true })
  lastLogin?: Date;

  @Column({ name: 'is_agree_terms', type: 'boolean', default: false })
  isAgreeTerms: boolean;

  @Column({ name: 'otp_expiry', type: 'timestamp', nullable: true })
  otpExpiry?: Date;

  @Column({ name: 'tenant_id', nullable: true })
  tenantId?: number;
 
  @Column({ name: 'is_active', default: true })
  isActive?: boolean;

  @Column({ name: 'is_deleted', default: false })
  isDeleted?: boolean;

  @BeforeInsert()
  async hashPassword(): Promise<void> {
    if (this.password) {
      this.password = await Helper.hashPassword(this.password.trim());
    }
  }

  @OneToMany(() => UserAuthProvider, (authProvider) => authProvider.user, {
    cascade: true,
  })
  authProviders: UserAuthProvider[];

  @OneToMany(() => UserPreference, (preference) => preference.user, {
    cascade: true,
  })
  preferences: UserPreference[];

  @OneToOne(() => UserProfile, (userProfile) => userProfile.user, {
    cascade: true,
    onDelete: 'CASCADE',
  })
  profile: UserProfile;

  @ManyToMany(() => Role, (role) => role.users, {
    cascade: true,
    onDelete: 'CASCADE',
  })
  @JoinTable({ name: 'user_roles' }) // Custom pivot table name
  roles: Role[];

  @OneToOne(() => TeamMember, (teamMember) => teamMember.user, {
    cascade: true,
  })
  teamMember: TeamMember;

  @ManyToOne(() => Tenant, (tenant) => tenant.users, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'tenant_id' })
  tenant: Tenant;

  @OneToMany(() => MediaRecord, (mediaRecord) => mediaRecord.user, {
    cascade: true,
    onDelete: 'CASCADE',
  })
  mediaRecords: MediaRecord[];
}
