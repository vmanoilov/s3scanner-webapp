# S3Scanner Web Application 🔍

<p align="center">
<img src="https://img.shields.io/badge/Version-2.0.0-blue.svg"/>
<img src="https://img.shields.io/badge/Docker-Ready-green.svg"/>
<img src="https://img.shields.io/badge/License-MIT-yellow.svg"/>
<img src="https://img.shields.io/badge/React-18.0-blue.svg"/>
<img src="https://img.shields.io/badge/FastAPI-Latest-green.svg"/>
</p>

A modern, full-stack web application for scanning S3 buckets across multiple cloud providers with advanced features including bucket name generation, real-time scanning, and comprehensive reporting.

## ✨ Features

### 🎯 **Core Functionality**
- **Multi-Provider Scanning**: AWS, DigitalOcean, GCP, Linode, Scaleway, Wasabi, and custom providers
- **Smart Bucket Discovery**: Intelligent bucket name generation with predefined categories
- **Real-time Scanning**: Live progress updates with WebSocket integration
- **Permission Analysis**: Comprehensive bucket permission and security assessment
- **Object Enumeration**: Detailed object listing and analysis

### 🎨 **Modern Web Interface**
- **Responsive Design**: Mobile-first, works on all devices
- **Dark/Light Themes**: Customizable UI themes
- **Interactive Dashboard**: Real-time charts and statistics
- **Advanced Filtering**: Multi-criteria search and filtering
- **Export Capabilities**: CSV, JSON, and PDF report generation

### 🚀 **Advanced Features**
- **Automated Scanning**: Scheduled scans with cron-like scheduling
- **API Integration**: RESTful API with comprehensive documentation
- **Database Storage**: PostgreSQL with full scan history
- **Message Queuing**: RabbitMQ for distributed scanning
- **Docker Deployment**: One-command deployment with Docker Compose

## 🏃‍♂️ Quick Start

### Prerequisites
- Docker and Docker Compose
- Git
- 4GB RAM minimum

### One-Command Deployment

```bash
# Clone and deploy
git clone <your-repo-url>
cd s3scanner-web
chmod +x start.sh
./start.sh
```

**That's it!** 🎉 Access your application at: **http://localhost:8080**

### Manual Setup

```bash
# Clone repository
git clone <your-repo-url>
cd s3scanner-web

# Start all services
docker-compose up -d

# Check status
docker-compose ps
```

## 📋 Service URLs

| Service | URL | Purpose |
|---------|-----|---------|
| **Main Application** | http://localhost:8080 | Complete web interface |
| Frontend | http://localhost:3000 | React frontend |
| Backend API | http://localhost:8000 | FastAPI with auto-docs |
| API Documentation | http://localhost:8000/docs | Interactive API docs |
| RabbitMQ Management | http://localhost:15672 | Queue monitoring |
| Database | localhost:5432 | PostgreSQL database |

**Default Credentials:**
- RabbitMQ: `guest` / `guest`
- Database: `s3scanner` / `password123`

## 🎯 Usage Guide

### 1. **Bucket Name Generation**
- Select categories: Finance, Software, Production, Personal, Testing, etc.
- Generate intelligent bucket name lists
- Custom pattern matching and wordlist combinations

### 2. **Scanning Operations**
- **Single Bucket**: Enter bucket name directly
- **Bulk Scanning**: Upload bucket lists or use generated names
- **Scheduled Scans**: Set up automated scanning intervals
- **Real-time Monitoring**: Live progress and result updates

### 3. **Results Analysis**
- **Permission Overview**: Visual permission matrix
- **Security Assessment**: Risk scoring and recommendations
- **Object Analysis**: File listing and metadata
- **Export Options**: Multiple format downloads

### 4. **API Integration**
```bash
# Health check
curl http://localhost:8000/health

# Start scan
curl -X POST http://localhost:8000/api/v1/scan \
  -H "Content-Type: application/json" \
  -d '{"bucket_name": "test-bucket", "provider": "aws"}'

# Get results
curl http://localhost:8000/api/v1/scans/{scan_id}
```

## 🛠️ Management Commands

```bash
# Application Management
./start.sh start     # Start all services
./start.sh stop      # Stop all services
./start.sh restart   # Restart services
./start.sh status    # Check service health
./start.sh logs      # View application logs
./start.sh clean     # Remove all containers and data

# Development
./start.sh dev       # Start in development mode
./start.sh test      # Run test suite
./start.sh build     # Build all images
```

## 🔧 Configuration

### Environment Variables

Create `.env` file:

```bash
# Application
APP_ENV=production
APP_DEBUG=false
APP_HOST=0.0.0.0
APP_PORT=8000

# Database
DB_HOST=db
DB_PORT=5432
DB_NAME=s3scanner
DB_USER=s3scanner
DB_PASSWORD=password123

# Redis
REDIS_HOST=redis
REDIS_PORT=6379

# RabbitMQ
RABBITMQ_HOST=rabbitmq
RABBITMQ_PORT=5672
RABBITMQ_USER=guest
RABBITMQ_PASSWORD=guest

# Security
SECRET_KEY=your-secret-key-here
JWT_SECRET=your-jwt-secret-here

# AWS Credentials (optional)
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
```

### Custom Providers

Add custom S3-compatible providers in `config/providers.yml`:

```yaml
custom_providers:
  vultr:
    endpoint_format: "https://{region}.vultrobjects.com"
    regions: ["ewr1", "sjc1", "ams1"]
    address_style: "path"
    
  minio:
    endpoint_format: "http://minio.local:9000"
    regions: ["us-east-1"]
    address_style: "path"
    insecure: true
```

## 🏗️ Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   React Frontend│    │  Nginx Proxy     │    │  FastAPI Backend│
│   (Port 3000)   ├────┤  (Port 8080)     ├────┤  (Port 8000)    │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                                         │
                       ┌─────────────────┐              │
                       │   PostgreSQL    ├──────────────┤
                       │   (Port 5432)   │              │
                       └─────────────────┘              │
                                                         │
                       ┌─────────────────┐              │
                       │   RabbitMQ      ├──────────────┘
                       │   (Port 5672)   │
                       └─────────────────┘
```

## 🧪 Testing

```bash
# Run all tests
./start.sh test

# Manual testing
docker-compose exec backend pytest
docker-compose exec frontend npm test
```

## 🚀 Production Deployment

### SSL/HTTPS Setup

```bash
# Generate SSL certificates
./scripts/generate-ssl.sh

# Update docker-compose.prod.yml
cp docker-compose.prod.yml docker-compose.yml

# Deploy with SSL
./start.sh start
```

### Monitoring Setup

```bash
# Add monitoring stack
./start.sh monitoring

# Access dashboards
# Grafana: http://localhost:3001
# Prometheus: http://localhost:9090
```

## 🛡️ Security Features

- **Rate Limiting**: API request throttling
- **CORS Protection**: Configurable cross-origin policies
- **Input Validation**: Comprehensive request validation
- **SQL Injection Prevention**: Parameterized queries
- **XSS Protection**: Content security policies
- **HTTPS Enforcement**: SSL/TLS encryption

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Documentation**: Check the `/docs` folder for detailed guides
- **Issues**: Report bugs on GitHub Issues
- **Discussions**: Join GitHub Discussions for questions
- **API Docs**: Visit http://localhost:8000/docs when running

## 🙏 Acknowledgments

- Original S3Scanner project by sa7mon
- React and FastAPI communities
- Docker and containerization ecosystem
- Security research community

---

<p align="center">
Made with ❤️ for the cybersecurity community
</p>