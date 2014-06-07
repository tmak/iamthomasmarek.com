
This is the repository for my website http://iamthomasmarek.com.
It's build with Middleman and hosted on AWS (Route 53, CloudFront, S3).
The design is responsive (mobile first).

# Build

```
bin/middleman build
```

# Run locally

```
bin/middleman
```

# Deploy

```
cp bin/deploy.sh.sample bin/deploy.sh
vim bin/deploy.sh
bin/deploy.sh
```