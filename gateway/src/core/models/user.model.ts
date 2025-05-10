import { Field, ID, ObjectType } from '@nestjs/graphql';

@ObjectType({ description: 'user' })
export class User {
  @Field(() => ID, { description: 'User ID' })
  id: string;
  @Field(() => String, { description: 'User Name' })
  username: string;
  @Field(() => String, { description: 'User Email' })
  email: string;
}
