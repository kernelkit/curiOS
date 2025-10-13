Contributing Guidelines
=======================

Thank you for taking the time to contribute to curiOS!

We welcome any help in the form of bug reports, fixes, or patches to add
new features. We prefer GitHub pull requests, but are open to other forms
of collaboration as well. Let's talk!


Getting Started
---------------

If you are unsure how to start implementing an idea or fix:

 - Open an issue at <https://github.com/kernelkit/curiOS/issues>
   - Use the bug report template for bugs
   - Use the feature request template for new containers or features
 - Contact us via [KernelKit](https://kernelkit.org)

> **Note:** Talking about code and problems first is often the best way
> to get started before submitting a pull request. We have found it
> always saves time, yours and ours.


General Guidelines
------------------

When submitting bug reports or patches, please state which version the
change is made against, what it does, and, more importantly **why** --
from your perspective, why is it a bug, why does the code need changing
in this way. Start with why.

 - **Bug reports** need metadata like curiOS version or commit hash
 - **Bug fixes** also need version, and (preferably) a corresponding
   issue number for the ChangeLog
 - **New features** need discussion first! Please open an issue or
   contact us before starting work on major changes
 - **New containers** should follow the existing pattern:
   - Create defconfigs for both amd64 and arm64
   - Add board-specific rootfs overlays if needed
   - Update the build workflow matrix
   - Document the container in README.md with examples

Please take care to ensure you follow the project coding style and commit
message format. If you follow these recommendations you help the
maintainers and make it easier for them to include your contributions.


Coding Style
------------

 - **Shell scripts**: Follow the existing style in `board/*/rootfs/`
   - Use POSIX sh when possible (not bash-specific features)
   - Use tabs for indentation
   - Keep scripts simple and maintainable

 - **Buildroot configs**: Follow Buildroot conventions
   - Use `make savedefconfig` to generate clean defconfigs
   - Keep configs minimal and focused

 - **Documentation**: Use clear, concise markdown
   - Include practical examples
   - Mention architecture support (amd64/arm64)
   - Document environment variables and volumes


Commit Messages
---------------

Please use the [Conventional Commits](https://www.conventionalcommits.org/)
format for your commit messages. This helps us generate meaningful changelogs.

Examples:

```
board: add ENABLE_INTERFACES support to nftables container

Allow nftables container to automatically bring up and down network
interfaces via the ENABLE_INTERFACES environment variable.

Fixes #20
```

```
workflows: fix tarball structure for podman/docker load

Remove directory wrapper from OCI tarballs to support podman load
and docker load commands.

Fixes #21
```

 - Use a short summary line (50-72 chars)
 - Add a blank line, then a more detailed description
 - Reference issue numbers with `Fixes #N` or `Closes #N`
 - Sign your commits with `Signed-off-by:` (use `git commit -s`)


Testing Changes
---------------

Before submitting a pull request:

1. **Build test**: Ensure your changes build for both amd64 and arm64
   ```bash
   make <container>_amd64_defconfig
   make
   make <container>_arm64_defconfig
   make
   ```

2. **Runtime test**: Test the resulting container image
   ```bash
   cd output/images
   podman load < rootfs-oci
   podman run --rm <image>:<tag>
   ```

3. **Documentation**: Update README.md if you've added features or
   changed behavior


Pull Request Process
---------------------

1. Fork the repository and create a branch for your changes
2. Make your changes following the guidelines above
3. Test your changes thoroughly
4. Push to your fork and submit a pull request
5. Address any review feedback

We'll review your PR as soon as possible. Please be patient and responsive
to feedback.


License
-------

By contributing to curiOS, you agree that your contributions will be
licensed under the GNU General Public License v2.0, the same license
as the project itself.


Questions?
----------

If you have questions about contributing, please open an issue or
contact us via [KernelKit](https://kernelkit.org).

Thank you for helping make curiOS better!
