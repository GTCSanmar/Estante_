Livraria do Duque - Missão Flutter

Este projeto implementa a arquitetura de uma livraria virtual com funcionalidades de inventário, avaliações e conformidade LGPD.

🚀 Detalhes da Missão e Grupo

Item

Detalhe

Turma

Desenvolvimento de Aplicativos par Dispositivos Móveis

Grupo

Livraria do Duque

Integrantes

Gabriel Tadeu Costa Sanmartin





🎯 Arquitetura e Entregas Comuns

O projeto segue a Clean Architecture (Separação entre Domínio, Data e Apresentação).

Funcionalidades Entregues:

Fluxo de Onboarding/LGPD: Aceite de termos por rolagem e botão de Revisão de Termos na Home Page.

Persistência de Dados (Supabase): Configuração completa das 4 entidades (Book, Author, Review, Reader).

CRUD Livros: Criação, Listagem, Edição e Remoção de livros.

Funcionalidade de Review: O Leitor pode abrir um diálogo para avaliar um livro (persistindo na tabela reviews).

Ponto Crítico de Estabilidade (Corrigido):

Roteamento: O AppConfig foi corrigido para usar initialRoute e routes de forma unificada, resolvendo o erro de navegação DartError: Could not find a generator for route.

Persistência: Erros de schema do Supabase (PGRST204, UUID inválido) foram resolvidos com o mapeamento correto de snake_case (book_id) no DTOs e a inserção do MOCK_READER_UUID.
