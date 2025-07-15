# 🔔 Self-Hosted ntfy Server on Fly.io

A production-ready ntfy server deployment for push notifications, hosted on Fly.io.

## 🚀 Quick Deploy

1. **Clone and setup**:

   ```bash
   git clone git@github.com:matteo1222/ntfy-server-fly.git
   cd ntfy-server-fly
   ```

2. **Configure fly.toml**:

   - Update `app = "your-app-name-ntfy"` with your desired app name

3. **Deploy to Fly.io**:
   ```bash
   fly auth login
   fly launch --no-deploy
   fly volumes create ntfy_data --size 1 --region sjc
   fly deploy
   ```

## 📋 Configuration

### Server Configuration (server.yml)

- **Base URL**: Configure your domain in `server.yml`
- **Cache**: Persistent storage via Fly.io volumes
- **Rate limiting**: Configured for reasonable usage
- **CORS**: Enabled for web access

### Environment Variables

- `TZ`: Timezone (default: UTC)
- Add any additional config via Fly.io secrets

## 🔧 Usage

### Send a notification:

```bash
curl -d "Hello World!" https://your-app-name-ntfy.fly.dev/your-topic
```

### Subscribe to notifications:

```bash
curl -s https://your-app-name-ntfy.fly.dev/your-topic/raw
```

### Web Interface:

Visit `https://your-app-name-ntfy.fly.dev` in your browser

## 🛠️ Development

### Local testing:

```bash
docker build -t ntfy-server .
docker run -p 8080:80 ntfy-server
```

### Update configuration:

1. Edit `server.yml`
2. Commit changes
3. Deploy: `fly deploy`

## 📊 Monitoring

- Health check endpoint: `/v1/health`
- Fly.io provides automatic health monitoring
- View logs: `fly logs`

## 🔒 Security

- No authentication enabled by default
- To enable auth, uncomment auth settings in `server.yml`
- Use Fly.io secrets for sensitive configuration

## 📈 Scaling

- Default: 1 instance, auto-stop when idle
- To scale: `fly scale count 2`
- Volume size: `fly volumes extend ntfy_data --size 2`

## 🐛 Troubleshooting

### Common issues:

- **502 errors**: Check `fly logs` for container issues
- **Storage full**: Increase volume size
- **Rate limiting**: Adjust limits in `server.yml`

### Useful commands:

```bash
fly status                 # Check app status
fly logs                   # View application logs
fly ssh console           # SSH into container
fly volumes list           # List volumes
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes
4. Test locally
5. Submit a pull request

## 📄 License

MIT License - feel free to use for your projects!
