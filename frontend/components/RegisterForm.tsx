import {
  Flex,
  TextInput,
  Select,
  PasswordInput,
  NumberInput,
  Button,
  Group,
  Card,
  Stack,
  Title,
} from "@mantine/core";

interface RegisterFormProps {
  name: String;
  isUser: boolean;
}
const RegisterForm = ({ name, isUser }: RegisterFormProps) => {
  return (
    <Card
      withBorder
      radius="xl"
      shadow="xl"
      p={48}
      sx={{ minWidth: 350 }}
      mx="auto"
    >
      <Stack spacing={"xl"}>
        <Title color="black" size="36px" align="center">
          Register
        </Title>

        <form>
          <Flex direction={"column"} gap={"xs"}>
            <Flex direction={"row"} gap={"xs"}>
              <TextInput label={name} />
              {isUser ? (
                <TextInput label="Surname" />
              ) : (
                <Select
                  label="Company Type"
                  data={["Transportation", "Car Rental", "Hotel"]}
                />
              )}
            </Flex>
            <TextInput label={"Email"} />
            <PasswordInput label="Password"></PasswordInput>
            <PasswordInput label="Confirm Password"></PasswordInput>
            <NumberInput label="Telephone" hideControls />

            {!isUser && <TextInput label="Adress" />}
            {!isUser && <TextInput label="Contact Information" />}
            {!isUser && <TextInput label="Business Registration" />}
            <Button
              styles={(theme) => ({
                root: {
                  backgroundColor: "#5D5FEF",
                },
              })}
            >
              Register
            </Button>
            {isUser ? (
              <Button variant="subtle" color="dark" radius="xs" compact>
                Not a user? Click here to register as company
              </Button>
            ) : (
              <Button variant="subtle" color="dark" radius="xs" compact>
                Not a company? Click here to register as user
              </Button>
            )}
            <Button variant="subtle" color="dark" radius="xs" compact>
              Already have an account? Click here to login
            </Button>
            <Group position="center">{}</Group>
          </Flex>
        </form>
      </Stack>
    </Card>
  );
};

export default RegisterForm;
