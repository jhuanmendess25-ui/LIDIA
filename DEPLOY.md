# 🚀 GUIA DE DEPLOY - PROJETO LIDIA

## Opções de Deploy

---

## 1️⃣ Vercel (Recomendado)

### Por que Vercel?
- ✅ Deploy automático via Git
- ✅ HTTPS gratuito
- ✅ CDN global
- ✅ Preview de PRs
- ✅ Domínio gratuito (.vercel.app)

### Passos

1. **Criar conta na Vercel**
   - Acesse: https://vercel.com
   - Sign up com GitHub

2. **Conectar Repositório**
   ```bash
   # Push seu código para GitHub
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/seu-usuario/projeto-lidia.git
   git push -u origin main
   ```

3. **Importar Projeto na Vercel**
   - Dashboard Vercel → New Project
   - Import Git Repository
   - Selecione seu repositório
   - Framework Preset: **Vite**
   - Build Command: `npm run build`
   - Output Directory: `dist`
   - Deploy!

4. **Configurar Domínio (Opcional)**
   - Settings → Domains
   - Adicione seu domínio customizado

### URL Final
```
https://projeto-lidia.vercel.app
```

---

## 2️⃣ Netlify

### Por que Netlify?
- ✅ Interface amigável
- ✅ Drag & drop deploy
- ✅ HTTPS automático
- ✅ Continuous deployment

### Passos

1. **Criar conta na Netlify**
   - Acesse: https://netlify.com
   - Sign up com GitHub

2. **Deploy via Git**
   ```bash
   # Push para GitHub (mesmo do Vercel)
   git push origin main
   ```

3. **Configurar no Netlify**
   - New site from Git
   - Conecte GitHub
   - Build command: `npm run build`
   - Publish directory: `dist`
   - Deploy site

4. **Configurações Adicionais**
   - Site settings → Domain management
   - Adicione domínio customizado

### URL Final
```
https://projeto-lidia.netlify.app
```

---

## 3️⃣ GitHub Pages

### Configuração

1. **Instalar gh-pages**
   ```bash
   npm install --save-dev gh-pages
   ```

2. **Adicionar scripts no package.json**
   ```json
   {
     "scripts": {
       "predeploy": "npm run build",
       "deploy": "gh-pages -d dist"
     },
     "homepage": "https://seu-usuario.github.io/projeto-lidia"
   }
   ```

3. **Configurar vite.config.ts**
   ```typescript
   export default {
     base: '/projeto-lidia/'
   }
   ```

4. **Deploy**
   ```bash
   npm run deploy
   ```

### URL Final
```
https://seu-usuario.github.io/projeto-lidia
```

---

## 4️⃣ Deploy Manual (Servidor Próprio)

### Requisitos
- Servidor com Node.js
- Nginx ou Apache
- Certificado SSL

### Passos

1. **Build do Projeto**
   ```bash
   npm run build
   ```

2. **Transferir para Servidor**
   ```bash
   scp -r dist/* usuario@servidor:/var/www/projeto-lidia
   ```

3. **Configurar Nginx**
   ```nginx
   server {
       listen 80;
       server_name seudominio.com;
       
       root /var/www/projeto-lidia;
       index index.html;
       
       location / {
           try_files $uri $uri/ /index.html;
       }
   }
   ```

4. **SSL com Let's Encrypt**
   ```bash
   sudo certbot --nginx -d seudominio.com
   ```

---

## 🔧 Configurações de Ambiente

### Variáveis de Ambiente (.env)

```env
# Exemplo de variáveis (se necessário no futuro)
VITE_API_URL=https://api.projetolidia.com.br
VITE_APP_NAME=Projeto LIDIA
VITE_ENV=production
```

### Build Otimizado

```bash
# Build com análise de bundle
npm run build -- --mode analyze

# Build com sourcemaps
npm run build -- --sourcemap
```

---

## ⚙️ Otimizações para Produção

### 1. Código

✅ **TypeScript** - Já implementado  
✅ **Code Splitting** - Vite faz automaticamente  
✅ **Tree Shaking** - Remove código não usado  
✅ **Minificação** - Build minifica automaticamente  

### 2. Assets

```bash
# Comprimir imagens (se houver no futuro)
npm install --save-dev imagemin imagemin-webp

# SVG otimizado - já usa Lucide (otimizado)
```

### 3. Performance

```typescript
// Lazy loading de páginas (implementar se necessário)
const Dashboard = lazy(() => import('./components/Dashboard'));
const StudentDashboard = lazy(() => import('./components/StudentDashboard'));
```

### 4. Cache

```javascript
// vite.config.ts
export default {
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          'react-vendor': ['react', 'react-dom'],
          'ui-vendor': ['lucide-react']
        }
      }
    }
  }
}
```

---

## 📊 Monitoramento

### Analytics (Futuro)

```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>

<!-- Vercel Analytics -->
<script defer src="/_vercel/insights/script.js"></script>
```

### Error Tracking

```bash
# Sentry (opcional)
npm install @sentry/react

# Configure em main.tsx
import * as Sentry from "@sentry/react";

Sentry.init({
  dsn: "https://xxxxx@sentry.io/xxxxx",
  environment: "production"
});
```

---

## 🔐 Segurança

### Headers de Segurança

#### Vercel (vercel.json)
```json
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-XSS-Protection",
          "value": "1; mode=block"
        }
      ]
    }
  ]
}
```

#### Netlify (_headers)
```
/*
  X-Frame-Options: DENY
  X-Content-Type-Options: nosniff
  X-XSS-Protection: 1; mode=block
  Referrer-Policy: no-referrer-when-downgrade
```

### HTTPS
- ✅ Vercel: Automático
- ✅ Netlify: Automático
- ✅ GitHub Pages: Automático
- ⚠️ Servidor próprio: Configurar Let's Encrypt

---

## 🧪 Testes Pré-Deploy

### Checklist

- [ ] Build sem erros
  ```bash
  npm run build
  ```

- [ ] Preview local funciona
  ```bash
  npm run preview
  ```

- [ ] Todos os jogos funcionam
- [ ] Navegação completa
- [ ] Responsividade mobile
- [ ] Performance aceitável (Lighthouse)
- [ ] Console sem erros
- [ ] LocalStorage funcionando

### Lighthouse Audit

```bash
# Instalar Lighthouse
npm install -g lighthouse

# Rodar audit
lighthouse http://localhost:4173 --view

# Metas:
# Performance: > 90
# Accessibility: > 90
# Best Practices: > 90
# SEO: > 90
```

---

## 🌐 DNS e Domínio

### Comprar Domínio
- Registro.br (Brasil)
- GoDaddy
- Namecheap

### Configurar DNS

#### Para Vercel
```
A     @     76.76.21.21
CNAME www   cname.vercel-dns.com
```

#### Para Netlify
```
A     @     75.2.60.5
CNAME www   projeto-lidia.netlify.app
```

---

## 🔄 CI/CD Automático

### GitHub Actions (.github/workflows/deploy.yml)

```yaml
name: Deploy

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Node
        uses: actions/setup-node@v2
        with:
          node-version: '18'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Build
        run: npm run build
        
      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v20
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.ORG_ID }}
          vercel-project-id: ${{ secrets.PROJECT_ID }}
```

---

## 📝 Pós-Deploy

### 1. Testar Produção
- [ ] Abrir URL de produção
- [ ] Fazer login como Professor
- [ ] Fazer login como Aluno
- [ ] Testar todos os 10 jogos
- [ ] Verificar responsividade
- [ ] Testar CRUD de alunos

### 2. Monitorar
- [ ] Verificar logs de erro
- [ ] Monitorar performance
- [ ] Checar analytics
- [ ] Revisar feedback de usuários

### 3. Documentar
- [ ] Atualizar README com URL
- [ ] Documentar processo de deploy
- [ ] Criar changelog de versões

---

## 🐛 Troubleshooting

### Problema: Build Falha

```bash
# Limpar cache
rm -rf node_modules package-lock.json
npm install

# Limpar build
rm -rf dist
npm run build
```

### Problema: Roteamento 404

**Vercel:** Adicione `vercel.json`
```json
{
  "rewrites": [
    { "source": "/(.*)", "destination": "/" }
  ]
}
```

**Netlify:** Adicione `_redirects`
```
/*    /index.html   200
```

### Problema: Assets não Carregam

Verifique `vite.config.ts`:
```typescript
export default {
  base: './' // ou '/projeto-lidia/' para subpath
}
```

### Problema: LocalStorage não Funciona

- Verifique se site está em HTTPS
- Teste em janela normal (não anônima)
- Limpe cache do navegador

---

## 📈 Próximos Passos Pós-Deploy

1. **Backend** (Futuro)
   - Node.js + Express
   - PostgreSQL/MongoDB
   - JWT Authentication
   - API REST

2. **Mobile** (Futuro)
   - React Native
   - Expo
   - Push notifications

3. **Melhorias**
   - PWA (Progressive Web App)
   - Offline support
   - Sincronização em nuvem
   - Mais jogos

---

## 📞 Suporte

### Problemas com Deploy?

1. Consulte documentação oficial:
   - [Vercel Docs](https://vercel.com/docs)
   - [Netlify Docs](https://docs.netlify.com)
   - [Vite Deploy Guide](https://vitejs.dev/guide/static-deploy)

2. Abra uma issue no GitHub

3. Entre em contato com suporte da plataforma

---

## ✅ Checklist Final de Deploy

- [ ] Código commitado e pushed
- [ ] Build sem erros
- [ ] Preview testado localmente
- [ ] Plataforma de deploy escolhida
- [ ] Projeto configurado na plataforma
- [ ] Deploy realizado com sucesso
- [ ] URL de produção funcionando
- [ ] Todos os jogos testados
- [ ] Performance aceitável
- [ ] HTTPS configurado
- [ ] Domínio customizado (opcional)
- [ ] Analytics configurado (opcional)
- [ ] Documentação atualizada

---

**🎉 Parabéns! Seu Projeto LIDIA está no ar!**

Não esqueça de compartilhar a URL com professores e testar com alunos reais.

---

**Desenvolvido com ❤️ para educação inclusiva**

**Projeto LIDIA - 2025**
