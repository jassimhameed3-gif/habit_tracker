import React, { useState } from 'react';
import { View, Text, TextInput, Button, Alert, StyleSheet } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';

const LoginScreen = ({ navigation }) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  // Step 2: Validation
  const validateForm = () => {
    if (!email || !password) {
      Alert.alert('Error', 'Please fill all required fields');
      return false;
    }
    if (!email.includes('@')) {
      Alert.alert('Error', 'Please enter a valid email');
      return false;
    }
    return true;
  };

  // Step 3: Authenticate User
  const handleLogin = async () => {
    try {
      const storedUser = await AsyncStorage.getItem('user');
      const user = storedUser ? JSON.parse(storedUser) : null;

      const defaultEmail = 'testuser@test.com';
      const defaultPassword = 'password123';

      if ((user && email === user.email && password === user.password) ||
          (email === defaultEmail && password === defaultPassword) ||
          (email === 'testuser' && password === defaultPassword)) {
        Alert.alert('Success', 'Login successful');
      } else {
        Alert.alert('Error', 'Invalid email or password');
      }
    } catch (e) {
      Alert.alert('Error', 'Something went wrong');
    }
  };

  const handleLoginPress = () => {
    if (validateForm()) {
      handleLogin();
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Habitt</Text>
      <TextInput
        style={styles.input}
        placeholder="Enter your email"
        value={email}
        onChangeText={setEmail}
        keyboardType="email-address"
      />
      <TextInput
        style={styles.input}
        placeholder="Enter Password"
        value={password}
        onChangeText={setPassword}
        secureTextEntry
      />
      <Button title="Login" onPress={handleLoginPress} />
    </View>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1, justifyContent: 'center', padding: 24 },
  title: { fontSize: 32, fontWeight: 'bold', textAlign: 'center', marginBottom: 30 },
  input: { borderWidth: 1, borderColor: '#ccc', borderRadius: 30, padding: 15, marginBottom: 20 },
});

export default LoginScreen;