import { Controller } from '@nestjs/common';
import { UserService } from './user.service';
import { GrpcMethod } from '@nestjs/microservices';
import {
  CreateUserRequest,
  FindUserByEmailRequest,
  FindUserByIdRequest,
  FindUserByUsernameRequest,
  UserResponse,
  UserServiceController,
} from 'types/proto/user';
import { Observable } from 'rxjs';

@Controller()
export class UserController implements UserServiceController {
  constructor(private readonly userService: UserService) {}
  createUser(
    request: CreateUserRequest,
  ): Promise<UserResponse> | Observable<UserResponse> | UserResponse {
    throw new Error('Method not implemented.');
  }
  findUserById(
    request: FindUserByIdRequest,
  ): Promise<UserResponse> | Observable<UserResponse> | UserResponse {
    throw new Error('Method not implemented.');
  }
  findUserByEmail(
    request: FindUserByEmailRequest,
  ): Promise<UserResponse> | Observable<UserResponse> | UserResponse {
    throw new Error('Method not implemented.');
  }
  findUserByUsername(
    request: FindUserByUsernameRequest,
  ): Promise<UserResponse> | Observable<UserResponse> | UserResponse {
    throw new Error('Method not implemented.');
  }
}
