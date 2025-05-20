import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';
import { join } from 'path';
import { ReflectionService } from '@grpc/reflection';
import { USER_PACKAGE_NAME } from 'types/proto/user';

async function bootstrap() {
  const grpcService = await NestFactory.createMicroservice<MicroserviceOptions>(
    AppModule,
    {
      transport: Transport.GRPC,
      options: {
        package: USER_PACKAGE_NAME,
        protoPath: join(
          '/home/bcila/Documents/Projects/twitch-clone-microservices/proto/user.proto',
        ),
        url: 'localhost:50051',
        onLoadPackageDefinition: (pkg, server) => {
          new ReflectionService(pkg).addToServer(server);
        },
      },
    },
  );

  const kafkaService =
    await NestFactory.createMicroservice<MicroserviceOptions>(AppModule, {
      transport: Transport.KAFKA,
      options: {
        client: {
          brokers: ['192.168.1.104:9092'],
        },
        consumer: {
          groupId: 'user-consumer',
        },
      },
    });

  await grpcService.listen();
  await kafkaService.listen();

  console.log('User service is running');
}
bootstrap();
