Documento de Requisitos de Produto (PRD) - Livraria do Duque

Metadado

Valor

Produto

Livraria do Duque (Catálogo e Inventário de Livros)

Versão

1.0 (Arquitetura Estável e Sincronizada)

Data de Criação

11 de Dezembro de 2025

Proprietário

Gabriel Tadeu

1. Visão Geral e Objetivos do Produto

O objetivo principal deste projeto é estabelecer uma base de código robusta em Flutter que demonstre as melhores práticas de arquitetura, persistência de dados e conformidade legal (LGPD). O foco funcional é o gerenciamento de um catálogo pessoal de livros, utilizando um backend moderno e uma arquitetura de dados otimizada para operação offline (Cache-First).

Objetivos Chave

Atingir a Clean Architecture: Estruturar o projeto com total separação entre Domínio, Dados e Apresentação para máxima testabilidade e modularidade.

Garantir o Compliance: Implementar um fluxo de primeiro acesso claro, garantindo o consentimento ativo do usuário (LGPD).

Estabelecer Persistência Híbrida: Utilizar Supabase (remoto) e SharedPreferences (cache local) com um fluxo de sincronização bidirecional.

Adotar Padrões Reativos: Implementar o gerenciamento de estado via Provider (ChangeNotifier) para desacoplar a UI da lógica de persistência.

2. Arquitetura e Estrutura Técnica

A arquitetura base é a Clean Architecture, com organização de código no padrão Feature-Sliced Design (divisão por domínio).

2.1. Camada de Persistência Híbrida

Componente

Tecnologia

Responsabilidade

Backend Remoto

Supabase (PostgreSQL)

Fonte de verdade (BookSupabaseDataSource).

Cache Local

SharedPreferences

Cache de lista de livros (BookSharedPreferencesDataSource).

Gerenciamento de Estado

Provider (BookStore)

Detentor do estado final da lista (List<Book>) e notificador da UI.

Repositório

BookRepositoryImpl

Orquestrador: Decide se carrega do Cache ou do Supabase e implementa a lógica de sincronização.

2.2. Entidades de Domínio (RF-0)

O sistema manipula quatro entidades principais, todas com estrutura Entity $\neq$ DTO + Mapper.

Entidade

Propósito no Sistema

Book

Entidade principal: Livro, inventário, e status de leitura.

Review

Avaliações e notas dos leitores para um Book.

Author

Dados dos criadores dos livros (listagem separada).

Reader

Entidade de usuário (referenciada para as Reviews).

3. Requisitos Funcionais (RFs)

RF1: Fluxo de Inicialização e Conformidade (LGPD)

ID

Requisito

Status

RF1.1

O aplicativo deve iniciar com um SplashPage que aguarda a inicialização assíncrona das dependências (Supabase, SharedPreferences).

CONCLUÍDO

RF1.2

A navegação para o Onboarding deve ser por pushReplacementNamed após a SplashPage.

CONCLUÍDO

RF1.3

A ConsentPage deve exigir a rolagem completa do documento de políticas para habilitar o botão FINALIZAR (Consentimento Ativo).

CONCLUÍDO

RF1.4

O usuário deve conseguir retornar para a ConsentPage via Drawer na HomePage para revisar ou revogar termos.

CONCLUÍDO

RF2: Gerenciamento do Catálogo (CRUD de Livros)

ID

Requisito

Status

RF2.1

A HomePage deve exibir a listagem completa dos livros (List<Book>).

CONCLUÍDO

RF2.2

O fluxo de Criação deve ser iniciado pelo FAB (+), abrindo o BookEditDialog.

CONCLUÍDO

RF2.3

O fluxo de Edição deve ser iniciado via BookDetailDialog ou toque longo.

CONCLUÍDO

RF2.4

O fluxo de Remoção deve exigir confirmação (BookRemoveDialog) e ser acionado por botão no diálogo ou swipe (Dismissible).

CONCLUÍDO

RF2.5

O padrão de listagem e CRUD deve ser replicado para a entidade Author (acessível via Drawer).

CONCLUÍDO

RF3: Arquitetura de Sincronização (Book Entity)

ID

Requisito

Status

RF3.1

A lista deve ser carregada prioritariamente do Cache Local (SharedPreferences) na inicialização da HomePage.

CONCLUÍDO

RF3.2

O BookRepositoryImpl deve iniciar a sincronização remota (syncBooks) em background após o carregamento do cache.

CONCLUÍDO

RF3.3

A persistência (Criação/Edição/Remoção) deve seguir o padrão Push-Then-Pull (atualiza remoto $\rightarrow$ sincroniza e atualiza cache local).

CONCLUÍDO

RF3.4

A UI deve exibir um loading e uma mensagem de erro (BookStore.errorMessage) se a sincronização falhar (com fallback para o cache local).

CONCLUÍDO

4. Requisitos de Não-Escopo (Exclusões Explícitas)

Os seguintes requisitos estão fora da Versão 1.0, mas fazem parte da evolução futura:

Autenticação de Usuário (Login/Registro).

Filtros e Ordenação avançada na listagem de livros.

Implementação do CRUD de Review e Author (o schema está pronto, mas a UI não delega o CRUD completo).

Sincronização Cache-First para as entidades Review e Author.
