# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in curiOS, please use GitHub's
built-in [Report a Vulnerability](https://github.com/kernelkit/curiOS/security/advisories/new)
feature for a private and secure disclosure.

When reporting, include:

- A clear description of the vulnerability
- Which container image(s) are affected
- Steps to reproduce the issue
- Potential impact of the vulnerability
- Suggested fix (if you have one)

## Supported Versions

We provide security updates only for the main branch and the most recent
stable release.

Older releases may receive critical security fixes on a best-effort basis.

## Security Updates

Security fixes are released as:

- New `:latest` tags pointing to patched versions
- Version-specific tags (e.g., `:1.2.3`) for stable releases
- Updated `:edge` tags from the main branch

We recommend:

- Use specific version tags (`:1.2.3`) for production deployments
- Monitor GitHub releases and security advisories
- Test `:latest` in staging before deploying to production

## Container Security Best Practices

When using curiOS containers:

1. **Use specific version tags** for reproducibility and control
2. **Run with minimal privileges** - avoid `--privileged` unless necessary
3. **Use read-only root filesystems** where possible (`--read-only`)
4. **Mount configs as read-only** (`:ro` suffix on volume mounts)
5. **Keep host systems updated** - container security depends on the host
6. **Monitor for updates** - subscribe to GitHub releases

## Dependency Security

curiOS containers are built on [Buildroot](https://buildroot.org/), which
includes various upstream components. We track security advisories for:

- Buildroot itself
- Linux kernel (for system container)
- Individual packages (nftables, ntpd, BusyBox, etc.)

## Acknowledgments

We appreciate the efforts of the security community to help improve the
security of curiOS. Thank you for your responsible disclosure.

## Contact

For security concerns that cannot be reported through GitHub:

- Email: security@kernelkit.org
- Website: https://kernelkit.org
