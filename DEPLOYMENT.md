# Venus One - Web Deployment Guide

## Production Build

The production-ready web build is in `build/web/` directory.

### Build Command Used
```bash
flutter build web --release --no-tree-shake-icons
```

## What's Included

### ✅ All Fixes Applied
- HTML loading screen with fallback mechanisms
- Firebase & Supabase initialization with timeouts
- Storage service with graceful degradation
- Comprehensive error handling
- Debug logging (stripped in release mode)

### ✅ Assets
- Environment variables (`.env`)
- All images and icons
- CanvasKit renderer files
- Service worker for offline support

## Deployment Options

### Option 1: Firebase Hosting (Recommended)

```bash
# Install Firebase CLI if not already installed
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase Hosting (if first time)
firebase init hosting
# Select: build/web as public directory
# Configure as single-page app: Yes
# Don't overwrite index.html: No

# Deploy
firebase deploy --only hosting
```

### Option 2: Netlify

1. **Via Netlify CLI**:
   ```bash
   npm install -g netlify-cli
   netlify login
   netlify deploy --prod --dir=build/web
   ```

2. **Via Netlify Dashboard**:
   - Drag and drop `build/web` folder
   - Or connect GitHub repo and set:
     - Build command: `flutter build web --release`
     - Publish directory: `build/web`

### Option 3: Vercel

```bash
npm install -g vercel
vercel --prod build/web
```

Or use Vercel Dashboard:
- Import GitHub repo
- Framework: Other
- Build command: `flutter build web --release`
- Output directory: `build/web`

### Option 4: GitHub Pages

```bash
# Install gh-pages if needed
npm install -g gh-pages

# Deploy (run from project root)
gh-pages -d build/web
```

### Option 5: Custom Server

Upload `build/web` contents to your web server.

**Required Server Configuration**:
- Serve `index.html` for all routes (SPA routing)
- Enable gzip compression for `.js` and `.wasm` files
- Set proper MIME types
- HTTPS recommended

**Nginx example**:
```nginx
server {
    listen 80;
    server_name venusone.app;
    root /var/www/venusone/build/web;

    # Gzip compression
    gzip on;
    gzip_types application/javascript application/wasm text/css;

    # SPA routing
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|wasm)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

**Apache example** (`.htaccess`):
```apache
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteBase /
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule . /index.html [L]
</IfModule>

# Enable compression
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE application/javascript
    AddOutputFilterByType DEFLATE application/wasm
    AddOutputFilterByType DEFLATE text/css
</IfModule>
```

## Environment Variables

The app uses `.env` file for sensitive configuration. Make sure to:

1. **Never commit sensitive values to git**
2. **Set environment variables on your hosting platform**:
   - `SUPABASE_URL` - Your Supabase project URL
   - `SUPABASE_ANON_KEY` - Your Supabase anon/public key

Most hosting platforms support environment variables:
- Firebase: `firebase functions:config:set`
- Netlify: Environment variables in dashboard
- Vercel: Environment variables in dashboard

## Domain Configuration

### Custom Domain Setup

1. **Add domain in hosting dashboard**
2. **Configure DNS**:
   ```
   Type: A
   Name: @ (or www)
   Value: [hosting IP]
   ```
   Or for CDN:
   ```
   Type: CNAME
   Name: www
   Value: [hosting CNAME]
   ```

3. **SSL/HTTPS**: Most modern hosting platforms auto-configure SSL

### Apple Sign-In Domain Setup

For Apple Sign-In to work on your custom domain:

1. Go to [Apple Developer Portal](https://developer.apple.com)
2. Navigate to: Certificates, IDs & Profiles > Services IDs
3. Edit your Service ID
4. Add your domain to "Domains and Subdomains"
5. Add return URL: `https://yourdomain.com/callback`
6. Update Supabase Apple OAuth settings with your domain

## Post-Deployment Checklist

- [ ] Test on multiple browsers (Chrome, Safari, Firefox, Edge)
- [ ] Test on mobile devices
- [ ] Verify Apple Sign-In works (if using)
- [ ] Check all routes load correctly
- [ ] Test offline functionality (service worker)
- [ ] Check console for errors
- [ ] Verify analytics are tracking
- [ ] Test performance (Lighthouse score)

## Performance Optimization

Current build is optimized with:
- ✅ Icon tree-shaking disabled (for stability)
- ✅ Release mode compilation
- ✅ CanvasKit renderer
- ✅ Service worker for caching

**Further optimizations**:
```bash
# Enable icon tree-shaking (reduces size)
flutter build web --release

# Use HTML renderer (smaller, less features)
flutter build web --release --web-renderer html

# Enable Wasm (experimental, faster)
flutter build web --release --wasm
```

## Monitoring & Analytics

The app includes:
- Firebase Analytics (for web)
- Firebase Crashlytics (mobile only)
- Admin analytics service

Check Firebase Console for:
- User engagement
- Page views
- Error reports
- Performance metrics

## Troubleshooting

### Issue: White screen after loading
**Solution**: Check browser console for errors. Usually a routing or initialization issue.

### Issue: Apple Sign-In not working
**Solution**:
1. Check domain is registered in Apple Developer Portal
2. Verify Supabase OAuth redirect URL
3. Check browser console for OAuth errors

### Issue: Assets not loading (404)
**Solution**: Verify `assets` folder was copied correctly during build.

### Issue: Service worker errors
**Solution**: Clear browser cache and service workers, then reload.

## Rollback

If deployment fails:
1. Keep previous `build/web` folder as backup
2. Use hosting platform's rollback feature
3. Or re-deploy previous version

## Support

For issues:
- Check browser console (F12)
- Review server logs
- Check Firebase/Supabase dashboards
- Review `WEB_DEBUGGING_GUIDE.md`

---

**Current Build**: Production-ready, tested locally at `http://localhost:8080`
**Last Updated**: 2026-01-29
**Status**: ✅ Ready for deployment
