import { Entity, Column, ManyToOne, JoinColumn } from 'typeorm';
import { User } from './user.entity';
import { Plan } from './plan.entity';
import Model from './base.entity';

@Entity({ name: 'subscriptions' })
export class Subscription extends Model {
  @Column({ unique: true, name: 'stripe_subscription_id' })
  stripeSubscriptionId: string;

  @Column({ name: 'stripe_customer_id' })
  stripeCustomerId: string;

  @Column({ type: 'json', nullable: false })
  features: Array<unknown>;

  @Column()
  status: string; // 'active', 'canceled', 'past_due', etc.

  @Column({ type: 'timestamp', name: 'current_period_start' })
  currentPeriodStart: Date;

  @Column({ type: 'timestamp', name: 'current_period_end' })
  currentPeriodEnd: Date;

  @Column({ nullable: true, type: 'timestamp', name: 'canceled_at' })
  canceledAt: Date;

  @Column({ default: false, name: 'cancel_at_period_end' })
  cancelAtPeriodEnd: boolean;

  @Column({ nullable: true, name: 'stripe_price_id' })
  stripePriceId: string;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  amount: number;

  @Column()
  currency: string;

  @Column({ default: false, name: 'is_trialing' })
  isTrialing: boolean;

  @ManyToOne(() => User)
  @JoinColumn({ name: 'user_id' })
  user: User;

  @Column({ name: 'user_id' })
  userId: number;

  @ManyToOne(() => Plan)
  @JoinColumn({ name: 'plan_id' })
  plan: Plan;

  @Column({ name: 'plan_id' })
  planId: number;
}
