# Terraform - Mini proyecto: nginx EC2 (módulo)

Resumen
- Proyecto de ejemplo que despliega dos instancias EC2 con Nginx usando un módulo reutilizable.
- Estado remoto en S3 (backend). Modularización en `nginx_server_module`.

Estructura del repositorio
- main.tf — backend S3 y llamadas a módulos (dev / qa).
- nginx_server_module/
  - variables.tf
  - ec2.tf
  - security_group.tf
  - key.tf
  - outputs.tf
- (Recomendado) providers.tf — proveedor AWS en raíz (no dentro de módulos).

Requisitos
- Terraform >= 1.x
- AWS CLI configurado localmente
- Perfil AWS con permisos para S3, EC2, IAM (key pair), y STS

Configurar credenciales (Windows PowerShell)
1. Configura un perfil seguro con AWS CLI (recomendado):
```powershell
aws configure --profile personal
```
2. Verifica el perfil:
```powershell
aws sts get-caller-identity --profile personal
```
3. Alternativa temporal en la sesión:
```powershell
$env:AWS_PROFILE = "personal"
```

Proveedor recomendado (archivo raíz)
- Crea `providers.tf` en la raíz del directorio terraform para usar el perfil:
```hcl
// filepath: c:\Fuentes\DevOps\Terraform\TerraformTestYT\terraform\providers.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = "us-east-2"      # ajustar según donde quieras crear recursos
  profile = "personal"
}
```

Backend S3 — atención a la región
- Asegúrate de que `main.tf` (backend "s3") usa la región correcta del bucket. Si el bucket está en `eu-central-1`, cambia `region` a `eu-central-1`.
- Para reconfigurar el backend:
```powershell
cd c:\Fuentes\DevOps\Terraform\TerraformTestYT\terraform
terraform init -reconfigure -backend-config="profile=personal"
# o especifica region si es necesario:
terraform init -reconfigure -backend-config="profile=personal" -backend-config="region=eu-central-1"
```

Flujo de trabajo (comandos)
```powershell
cd c:\Fuentes\DevOps\Terraform\TerraformTestYT\terraform
terraform init -reconfigure -backend-config="profile=personal"
terraform validate
terraform plan -out plan.tfplan
terraform apply "plan.tfplan"
```

Outputs
- El módulo exporta la IP pública y DNS de la instancia (`server_public_ip`, `server_public_dns`).

Seguridad — acciones urgentes
- Revoca/rota inmediatamente cualquier access key que haya estado en el repositorio.
- Elimina archivos que contengan credenciales:
```powershell
git rm --cached "ruta/al/archivo-con-secretos"
git commit -m "Remove secrets"
git push
```
- Si es necesario eliminar del historial, usa herramientas como BFG o git filter-repo.

Errores comunes y soluciones rápidas
- "No valid credential sources found" → Asegúrate de que AWS_PROFILE o variables de entorno estén activas en la sesión, o pon `profile = "personal"` en `providers.tf`.
- "requested bucket from <región>, actual location <otra región>" (StatusCode: 301) → El backend usa una región distinta a la del bucket. Actualiza `region` en `backend "s3"` o crea/usa un bucket en la región deseada.
- Si usas AWS SSO:
```powershell
aws sso login --profile personal
$env:AWS_PROFILE = "personal"
```

Notas finales
- No dejar claves en los ficheros del repo.
- Mantener provider en la raíz, no en módulos.
- Si necesitas, puedo generar un archivo providers.tf o ayudarte a purgar el historial git.
