import { useState, useEffect } from 'react';
import { Login } from './components/Login';
import { SignUp } from './components/SignUp';
import { ProfessorSignUp } from './components/ProfessorSignUp';
import { Dashboard } from './components/Dashboard';
import { StudentDashboard } from './components/StudentDashboard';
import { DataProvider } from './contexts/DataContext';
import { Toaster } from './components/ui/sonner';
import { projectId, publicAnonKey } from './utils/supabase/info.tsx';

export default function App() {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [userType, setUserType] = useState<'professor' | 'student' | null>(null);
  const [userId, setUserId] = useState<string | null>(null);
  const [showSignUp, setShowSignUp] = useState(false);
  const [showProfessorSignUp, setShowProfessorSignUp] = useState(false);
  const [isInitializing, setIsInitializing] = useState(true);

  useEffect(() => {
    // Initialize default professor account (non-blocking)
    const initializeProfessor = async () => {
      // Only try to initialize if we have valid Supabase config
      if (!projectId || !publicAnonKey || projectId === 'YOUR_PROJECT_ID' || publicAnonKey === 'YOUR_ANON_KEY') {
        console.log('Skipping professor initialization - Supabase not configured');
        return;
      }

      try {
        // Add timeout to prevent hanging
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), 5000); // 5 second timeout

        const response = await fetch(
          `https://${projectId}.supabase.co/functions/v1/lidia-api/init-professor`,
          {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              'Authorization': `Bearer ${publicAnonKey}`
            },
            signal: controller.signal
          }
        );

        clearTimeout(timeoutId);

        if (response.ok) {
          const data = await response.json();
          console.log('Professor initialization:', data.message || 'Success');
        }
      } catch (error) {
        // Silently handle errors - this is optional initialization
        if ((error as Error).name === 'AbortError') {
          console.log('Professor initialization timed out');
        } else {
          console.log('Professor initialization skipped:', (error as Error).message);
        }
      }
    };

    // Don't await - run in background
    initializeProfessor();

    // Check for saved session (don't wait for professor init)
    const session = localStorage.getItem('lidia_session');
    const savedUserType = localStorage.getItem('lidia_user_type') as 'professor' | 'student' | null;
    const savedUserId = localStorage.getItem('lidia_user_id');
    const savedAccessToken = localStorage.getItem('lidia_access_token');
    
    if (session && savedUserType && savedAccessToken) {
      setIsAuthenticated(true);
      setUserType(savedUserType);
      setUserId(savedUserId);
    }
    
    setIsInitializing(false);
  }, []);

  const handleLogin = async (username: string, password: string, type: 'professor' | 'student'): Promise<boolean> => {
    try {
      // MODO DE ACESSO LIVRE - Aceita qualquer credencial
      if (!username || !password) {
        return false;
      }

      // Normalizar username
      const normalizedUsername = username.toLowerCase().trim();
      
      console.log('Login com acesso livre permitido', { username: normalizedUsername, type });

      // Gera um token fake mas único
      const fakeToken = `fake_token_${Date.now()}_${Math.random().toString(36).substring(7)}`;
      const fakeUserId = `user_${normalizedUsername}_${Date.now()}`;

      // Save session - aceita qualquer login
      localStorage.setItem('lidia_session', 'active');
      localStorage.setItem('lidia_user_type', type);
      localStorage.setItem('lidia_user_id', type === 'student' ? normalizedUsername : fakeUserId);
      localStorage.setItem('lidia_access_token', fakeToken);
      
      console.log('Login aceito (modo livre), autenticação bem-sucedida');
      setIsAuthenticated(true);
      setUserType(type);
      setUserId(type === 'student' ? normalizedUsername : fakeUserId);
      
      return true;
    } catch (error) {
      console.error('Login error:', error);
      return false;
    }
  };

  const handleSignUpSuccess = async (matricula: string, password: string) => {
    // Automatically log in after successful signup
    const success = await handleLogin(matricula, password, 'student');
    if (success) {
      setShowSignUp(false);
    }
  };

  const handleProfessorSignUpSuccess = async (username: string, password: string) => {
    // Automatically log in after successful professor signup
    console.log('Professor signup success callback - attempting auto-login...', { username });
    
    // Aguardar um pouco para garantir que o perfil foi salvo
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    const success = await handleLogin(username, password, 'professor');
    if (success) {
      console.log('Auto-login successful!');
      setShowProfessorSignUp(false);
    } else {
      console.error('Auto-login failed after signup');
      // Mesmo se o auto-login falhar, fechar o signup para permitir login manual
      setShowProfessorSignUp(false);
      alert('Conta criada com sucesso! Por favor, faça login manualmente.');
    }
  };

  const handleLogout = () => {
    localStorage.removeItem('lidia_session');
    localStorage.removeItem('lidia_user_type');
    localStorage.removeItem('lidia_user_id');
    localStorage.removeItem('lidia_access_token');
    setIsAuthenticated(false);
    setUserType(null);
    setUserId(null);
  };

  if (isInitializing) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-emerald-50 via-blue-50 to-yellow-50 flex items-center justify-center">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-emerald-600 border-t-transparent rounded-full animate-spin mx-auto mb-4" />
          <p className="text-emerald-800">Carregando...</p>
        </div>
      </div>
    );
  }

  if (!isAuthenticated || !userType) {
    if (showSignUp) {
      return (
        <SignUp 
          onBack={() => setShowSignUp(false)} 
          onSignUpSuccess={handleSignUpSuccess}
        />
      );
    }
    if (showProfessorSignUp) {
      return (
        <ProfessorSignUp 
          onBack={() => setShowProfessorSignUp(false)} 
          onSignUpSuccess={handleProfessorSignUpSuccess}
        />
      );
    }
    return (
      <Login 
        onLogin={handleLogin} 
        onShowSignUp={() => setShowSignUp(true)}
        onShowProfessorSignUp={() => setShowProfessorSignUp(true)}
      />
    );
  }

  return (
    <DataProvider>
      {userType === 'student' ? (
        <StudentDashboard onLogout={handleLogout} userId={userId || ''} />
      ) : (
        <Dashboard onLogout={handleLogout} />
      )}
      <Toaster position="top-right" richColors />
    </DataProvider>
  );
}