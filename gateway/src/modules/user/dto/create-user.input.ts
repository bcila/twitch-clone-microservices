import { InputType, Field } from '@nestjs/graphql';

@InputType()
export class CreateUserInput {
  @Field(() => String, { description: 'username' })
  username: string;
  @Field(() => String, { description: 'email' })
  email: string;
  @Field(() => String, { description: 'password' })
  password: string;
}
