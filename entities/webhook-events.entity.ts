import { Entity, Column } from 'typeorm';
import Model from './base.entity';

@Entity({ name: 'webhook_events' })
export class WebhookEvent extends Model {
  @Column({ nullable: true, name: 'event_type' })
  eventType: string; // Example: 'user.created', 'user.updated', 'role.assigned'

  @Column({ type: 'json', nullable: true })
  payload: Record<string, unknown>; // Payload of the webhook event

  @Column({ nullable: true })
  status: string; // Example: 'pending', 'processed', 'failed'

  @Column({ nullable: true })
  source: string; // Source of the webhook event

  @Column({ nullable: true, name: 'target_url' })
  targetUrl: string; // URL where the webhook was sent

  @Column({ nullable: true, name: 'retry_count' })
  retryCount: number; // Number of retry attempts

  @Column({ nullable: true, name: 'error_message' })
  errorMessage: string; // Store error message if webhook delivery fails
}
