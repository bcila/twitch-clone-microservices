import { Injectable } from '@nestjs/common';
import { CreateUserInput } from './dto/create-user.input';
import { UpdateUserInput } from './dto/update-user.input';

@Injectable()
export class UserService {
  create(createUserInput: CreateUserInput) {
    return {
      exampleField: createUserInput.exampleField,
    };
  }

  findAll() {
    return `This action returns all user`;
  }

  findOne(id: number) {
    return `This action returns a #${id} user`;
  }

  update(id: number, updateUserInput: UpdateUserInput) {
    return {
      exampleField: updateUserInput.exampleField,
    };
  }

  remove(id: number) {
    return `This action removes a #${id} user`;
  }
}
