import * as crypto from 'crypto';

const SECRET = process.env.STREAM_KEY_SECRET!;

export function generateStreamKey(userId: string): string {
  const timestamp = Math.floor(Date.now() / 1000);
  const payload = `${userId}:${timestamp}`;
  const hmac = crypto
    .createHmac('sha256', SECRET)
    .update(payload)
    .digest('hex');
  return `live_${Buffer.from(`${payload}:${hmac}`).toString('base64url')}`;
}

export function verifyStreamKey(streamKey: string): boolean {
  try {
    const decoded = Buffer.from(
      streamKey.replace('live_', ''),
      'base64url',
    ).toString();
    const [userId, timestampStr, hmac] = decoded.split(':');
    const payload = `${userId}:${timestampStr}`;
    const expectedHmac = crypto
      .createHmac('sha256', SECRET)
      .update(payload)
      .digest('hex');

    // Opsiyonel: timestamp ile expire süresi kontrolü
    const ageInSeconds =
      Math.floor(Date.now() / 1000) - parseInt(timestampStr, 10);
    if (ageInSeconds > 60 * 60 * 24 * 7) return false; // 1 hafta geçerli

    return hmac === expectedHmac;
  } catch {
    return false;
  }
}
