# Data Storage & Schema — SystemCleaner

## 1. Data Store Strategy
SystemCleaner does not require an external SQL engine. It leverages:
1. **Windows System Registry**: Single source of truth for installed software registrations (`HKLM` and `HKCU`).
2. **Windows Package Repository**: Appx/MSIX store app state via Windows AppModel APIs.
3. **Structured Log Files**: JSON and text audit records stored in `apps/SystemCleaner/logs/`.

## 2. Catalog Definition Schema
Target removal items are stored as in-memory structured hashtables:

```powershell
@{
    Id          = "Apple_iCloud"
    DisplayName = "iCloud"
    Type        = "MSI"
    Guid        = "{8808B208-87D1-4725-8192-76D257E9DEAE}"
    Category    = "AppleSuite"
    Order       = 10
}
```

## 3. Audit Log Format
Log files are written to `logs/cleanup_report.log` using standard UTF-8 encoding:
```
[2026-10-24 13:50:00] [INFO] Target detected: Google Maps Blaster ({BB4EA525-...})
[2026-10-24 13:50:04] [SUCCESS] Uninstalled: Google Maps Blaster (ExitCode: 0)
```
