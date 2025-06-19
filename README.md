# S3Scanner Web Application 🔍

<p align="center">
<img src="https://img.shields.io/badge/Version-2.0.0-blue.svg"/>
<img src="https://img.shields.io/badge/Docker-Ready-green.svg"/>
<img src="https://img.shields.io/badge/License-MIT-yellow.svg"/>
<img src="https://img.shields.io/badge/Go-1.23-blue.svg"/>
<img src="https://img.shields.io/badge/S3Scanner-WebApp-green.svg"/>
</p>

**Repository**: [https://github.com/vmanoilov/s3scanner-webapp](https://github.com/vmanoilov/s3scanner-webapp)

A modern, full-stack application for scanning S3 buckets across multiple cloud providers with advanced features including intelligent bucket discovery, real-time scanning, and comprehensive reporting.

## ✨ Features

### 🎯 **Core Functionality**
- **Multi-Provider Scanning**: AWS, DigitalOcean, GCP, Linode, Scaleway, Wasabi, and custom providers
- **Smart Bucket Discovery**: Intelligent bucket name validation and detection
- **Real-time Scanning**: Concurrent scanning with progress tracking
- **Permission Analysis**: Comprehensive bucket permission and security assessment
- **Object Enumeration**: Detailed object listing and analysis
- **Database Storage**: PostgreSQL integration for scan history

### 🚀 **Advanced Features**
- **Message Queuing**: RabbitMQ for distributed scanning workloads
- **Docker Deployment**: One-command deployment with Docker Compose
- **Configuration Management**: Flexible provider and database configuration
- **Comprehensive Testing**: Unit and integration tests included
- **CI/CD Ready**: GitHub Actions workflows for automated builds

## 🏃‍♂️ Quick Start

### Prerequisites
- Docker and Docker Compose
- Git
- 4GB RAM minimum

### One-Command Deployment

```bash
# Clone and deploy
git clone https://github.com/vmanoilov/s3scanner-webapp.git
cd s3scanner-webapp
chmod +x start.sh
./start.sh
```

**That's it!** 🎉 Your S3Scanner is now running!

### Manual Setup

```bash
# Clone repository
git clone https://github.com/vmanoilov/s3scanner-webapp.git
cd s3scanner-webapp

# Start all services
docker-compose up -d

# Check status
docker-compose ps
```

## 📋 Service Configuration

| Service | Port | Purpose |
|---------|------|---------|
| **S3Scanner API** | 8080 | Main scanning service |
| **Database** | 5432 | PostgreSQL database |
| **Message Queue** | 5672 | RabbitMQ for job processing |
| **Queue Management** | 15672 | RabbitMQ web interface |

**Default Credentials:**
- RabbitMQ: `guest` / `guest`
- Database: `postgres` / `example`

## 🎯 Usage Guide

### 1. **Single Bucket Scanning**
```bash
# Scan a specific bucket
./s3scanner -bucket my-test-bucket -provider aws

# Scan with enumeration
./s3scanner -bucket my-test-bucket -provider aws -enumerate

# Scan and save to database
./s3scanner -bucket my-test-bucket -provider aws -db
```

### 2. **Bulk Scanning**
```bash
# Scan from file
./s3scanner -bucket-file buckets.txt -provider aws

# Use message queue for distributed scanning
./s3scanner -mq -provider aws -threads 10
```

### 3. **Multi-Provider Support**
```bash
# Scan DigitalOcean Spaces
./s3scanner -bucket my-space -provider digitalocean

# Scan custom S3-compatible provider
./s3scanner -bucket my-bucket -provider custom

# Scan Wasabi
./s3scanner -bucket my-wasabi-bucket -provider wasabi
```

### 4. **Advanced Options**
```bash
# Verbose logging
./s3scanner -bucket test -provider aws -verbose

# JSON output
./s3scanner -bucket test -provider aws -json

# Multiple threads
./s3scanner -bucket-file buckets.txt -provider aws -threads 20
```

## 🛠️ Configuration

### Environment Variables

Create `config.yml`:

```yaml
# Database configuration
db:
  uri: "postgresql://postgres:example@db_dev:5432/postgres"

# Message queue configuration  
mq:
  queue_name: "aws"
  uri: "amqp://guest:guest@localhost:5672"

# Custom provider example
providers:
  custom:
    insecure: false
    endpoint_format: "https://$REGION.vultrobjects.com"
    regions:
      - "ewr1"
    address_style: "path"
```

### Docker Environment

Set environment variables in `.env`:

```bash
# Database
POSTGRES_USER=postgres
POSTGRES_PASSWORD=example
POSTGRES_DB=postgres

# RabbitMQ
RABBITMQ_DEFAULT_USER=guest
RABBITMQ_DEFAULT_PASS=guest
```

## 🏗️ Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   S3Scanner     │    │   PostgreSQL     │    │   RabbitMQ      │
│   Application   ├────┤   Database       ├────┤   Message Queue │
│   (Port 8080)   │    │   (Port 5432)    │    │   (Port 5672)   │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### Components

- **Core Scanner**: Go-based S3 bucket scanner with multi-provider support
- **Database Layer**: PostgreSQL for storing scan results and history
- **Message Queue**: RabbitMQ for distributed scanning workloads
- **Provider System**: Modular support for different cloud providers
- **Worker System**: Concurrent scanning with configurable thread pools

## 🧪 Testing

```bash
# Run unit tests
go test ./...

# Run integration tests (requires test services)
TEST_DB=1 TEST_MQ=1 go test ./...

# Run with coverage
go test ./... -coverprofile=cover.out
go tool cover -html=cover.out
```

## 🚀 Development

### Building from Source

```bash
# Build the application
go build -o s3scanner .

# Build helper tools
go build -o mqingest ./cmd/mqingest/

# Run locally
./s3scanner -bucket test-bucket -provider aws -verbose
```

### Adding Custom Providers

1. Implement the `StorageProvider` interface in `provider/`
2. Add provider regions to `ProviderRegions` map
3. Update provider factory in `NewProvider()` function
4. Add tests for your provider

### Docker Development

```bash
# Development with auto-rebuild
docker-compose -f .dev/docker-compose.yml up

# Run with MITM proxy for debugging
docker-compose -f .dev/docker-compose.yml --profile dev-mitm up
```

## 🛡️ Security Features

- **Input Validation**: Comprehensive bucket name validation
- **Rate Limiting**: Configurable request throttling
- **Secure Defaults**: Anonymous credentials by default
- **SSL/TLS Support**: Configurable SSL verification
- **Access Control**: Granular permission checking

## 📊 Supported Providers

| Provider | Regions | Address Style | Status |
|----------|---------|---------------|--------|
| **AWS** | All regions | Virtual Host | ✅ Full Support |
| **DigitalOcean** | 10 regions | Path | ✅ Full Support |
| **Google Cloud** | Global | Path | ✅ Full Support |
| **Linode** | 25 regions | Virtual Host | ✅ Full Support |
| **Scaleway** | 3 regions | Path | ✅ Full Support |
| **Wasabi** | 15 regions | Path | ✅ Full Support |
| **Dreamhost** | 1 region | Path | ✅ Full Support |
| **Custom** | Configurable | Both | ✅ Full Support |

## 🤝 Contributing

1. Fork the repository: [https://github.com/vmanoilov/s3scanner-webapp](https://github.com/vmanoilov/s3scanner-webapp)
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open Pull Request

### Development Guidelines

- Follow Go best practices and conventions
- Add tests for new functionality
- Update documentation for new features
- Ensure Docker compatibility

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Repository**: [https://github.com/vmanoilov/s3scanner-webapp](https://github.com/vmanoilov/s3scanner-webapp)
- **Issues**: Report bugs on [GitHub Issues](https://github.com/vmanoilov/s3scanner-webapp/issues)
- **Discussions**: Join [GitHub Discussions](https://github.com/vmanoilov/s3scanner-webapp/discussions)
- **Documentation**: Check the repository wiki

## 🙏 Acknowledgments

- Original S3Scanner project by [sa7mon](https://github.com/sa7mon/S3Scanner)
- Go community for excellent tooling
- Docker and containerization ecosystem
- Security research community

## 📈 Project Stats

![GitHub stars](https://img.shields.io/github/stars/vmanoilov/s3scanner-webapp)
![GitHub forks](https://img.shields.io/github/forks/vmanoilov/s3scanner-webapp)
![GitHub issues](https://img.shields.io/github/issues/vmanoilov/s3scanner-webapp)
![GitHub license](https://img.shields.io/github/license/vmanoilov/s3scanner-webapp)

---

<p align="center">
<strong>Made with ❤️ for the cybersecurity community</strong><br>
<a href="https://github.com/vmanoilov/s3scanner-webapp">⭐ Star this repository</a>
</p>