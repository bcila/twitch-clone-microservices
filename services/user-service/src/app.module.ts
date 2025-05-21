import { Module } from '@nestjs/common';
import { UserModule } from './user/user.module';
import { ProfileModule } from './profile/profile.module';
import { PrismaService } from './prisma.service';

@Module({
  imports: [UserModule, ProfileModule],
  controllers: [],
  providers: [PrismaService],
})
export class AppModule {}
