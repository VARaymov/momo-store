# Общее устройство

Пельменная - https://momo-store.valery-rayumov.ru <br>
ArgoCD - https://argo-cd.valery-rayumov.ru

Сервисы пельменной работают в k8s-кластере Яндекс Cloud.

Для развёртывания кластера используется Terraform.

При сборке сервисов мы получаеми их Docker-образы, далее эти образы описываются в helm-чарте.

Развёрнутый в кластере ArgoCD подключен к nexus-репозиторию, где хранится helm-чарт приложения, он же и разворачивает наши сервисы в k8s.

# Развёртывание инфраструктуры и приложения.

- Устанавливаем terraform (https://developer.hashicorp.com/terraform/downloads)
- Устанавливаем Yandex CLI (https://cloud.yandex.ru/docs/cli/operations/install-cli), настраиваем свой профиль в яндекс облаке.
- Через UI создаем федерацию, облако и folder, запоминаем id этих сущностей.
- Инициализируем профиль ``yc init``. 
- Получение данных о профиле - `yc config list`
- Создаём yc токен `yc iam create-token`
- Записываем значение token, cloud_id, folder_id s3_bucket_name в **infrastructure/s3-backend/terraform.tvars** и **infrastructure/main/terraform.tvars**
- Создаём бакет для хранения состояния основного terraform. выполняем `terraform appply` в **infrastructure/s3-backend**
- Инициализируем terraform: выполняем в папке **infrastructure/main/** команду ``terraform init``
- Выполняем `terraform apply`.
- Получаем конфиг кластера командой ``kubectl get managed-kubernetes cluster --name momo-store-cluster get-credentials --external --force``
- Поднимаем ingress-controller в кластере: выполняем в папке **infrastructure/ingress-nginx/** команду ``kubectl apply -f ingress-deploy.yaml``
- Поднимаем cert-manager в кластере: выполняем в папке **infrastructure/cert-manager/** команду ``kubectl apply -f cert-manager-deploy.yaml``
- Создаем ClusterIssuer для cert-manager: выполняем в папке **infrastructure/cert-manager/** команду ``kubectl apply -f clusterIssuer-deploy.yaml``
- Поднимаем ArgoCD: выполняем в папке **infrastructure/argo-cd/** команду ``kubectl apply -f `` поочередно для namespace-argo-cd.yaml, deploy-argo-cd.yaml, ingress-service-argo-cd.yaml, user.yaml, user-policy.yaml
- Получаем пароль от учетки администратора в ArgoCD: выполняем команду ``kubectl -n argocd get secret argocd-initial-admin-secret -o=jsonpath='{.data.password}' | base64 --decode``. Заходим в эту учетку через UI и меняем пароль.
- Логинимся в ArgoCD через консоль командой ``argocd login argo-cd.valery-rayumov.ru``
- Меняем пароль для созданной сервисной учетки "momo" командой ``argocd account update-password --account momo``
- Запускаем деплой приложения: выполняем в папке **infrastructure/argo-cd/application** команду ``kubectl apply -f `` поочередно для repository-secret.yaml, app-project.yaml, application.yaml

# Обновления приложения и инфраструктуры
- При внесении изменений в директории "backend" или "frontend" запускается pipeline для формирования helm-чарта и его отправки в nexus.
- Вся инфраструктура описана в коде, при необходимости изменения следует вносить в ***.tf** файлы или ***.yaml** файлы сервисов(**infrastructure**). Далее выполнить ``terraform apply``.
