import {
    Entity,
    Column,
    Index,
} from 'typeorm';
import Model from './base.entity';

@Entity('invites')
@Index(['id', 'email', 'roleId'])
export class Invite extends Model {
    @Column()
    email: string;

    @Column()
    token: string;

    @Column()
    roleId: number;

    @Column({ name: "invited_by_id" })
    invitedById: number;

    @Column({ name: "tenant_id" })
    tenantId: number;
}
