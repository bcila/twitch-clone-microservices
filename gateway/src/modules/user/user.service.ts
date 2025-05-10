import { Injectable } from '@nestjs/common';
import { CreateUserInput } from './dto/create-user.input';
import { UpdateUserInput } from './dto/update-user.input';

@Injectable()
export class UserService {
  users = [
    {
      id: '1',
      username: 'John Doe',
      email: 'asd@asd.com',
    },
    {
      id: '2',
      username: 'Jane Doe',
      email: 'asd2@asd.com',
    },
    {
      id: '3',
      username: 'Jack Doe',
      email: 'asd3@asd,com',
    },
  ];

  create(createUserInput: CreateUserInput) {
    return {
      id: '99',
      username: createUserInput.username,
      email: createUserInput.email,
    };
  }

  findAll() {
    return this.users;
  }

  findOne(id: string) {
    return this.users.find((user) => user.id === id);
  }

  update(id: string, updateUserInput: UpdateUserInput) {
    const user = this.users.find((user) => user.id === id);
    if (!user) {
      return null;
    }
    return {
      id: user.id,
      username: updateUserInput.username ?? user.username,
      email: updateUserInput.email ?? user.email,
    };
  }

  remove(id: string) {
    return this.users.find((user) => user.id === id);
  }
}
