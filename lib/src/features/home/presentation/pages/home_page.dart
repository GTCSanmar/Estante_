import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:estante/src/shared/theme/app_theme.dart';
import 'package:estante/src/features/home/domain/entities/book.dart';
import 'package:estante/src/shared/widgets/book_detail_dialog.dart';
import 'package:estante/src/shared/widgets/book_edit_dialog.dart'; 
import 'package:estante/src/shared/widgets/book_remove_dialog.dart'; 
import 'package:estante/src/features/profile/presentation/profile_controller.dart'; // NOVO CONTROLLER

import 'package:estante/src/features/home/presentation/dialogs/book_actions_dialog.dart';
import 'package:estante/src/shared/constants/app_routes.dart';
import 'package:estante/src/features/home/presentation/book_store.dart'; 
import 'dart:io'; // Para FileImage
import '../../../../../main.dart'; 
// CRÍTICO: Importação real do image_picker (agora deve estar funcionando no seu pubspec.yaml)
import 'package:image_picker/image_picker.dart' as ipk; 


// MOCK: Definição da enumeração para simular ImageSource do image_picker
enum ImageSource { camera, gallery }


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    // CRÍTICO: Carrega os livros através da Store (que fará o Cache-First)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookStore>(context, listen: false).loadBooks();
    });
  }
  
  // CRÍTICO: Métodos de CRUD usam a Store
  
  void _openCreateDialog(BookStore store) async {
    final newBook = await showDialog<Book>(
      context: context,
      // CRÍTICO: Uso direto do widget importado
      builder: (context) => BookEditDialog(
        book: Book(id: '0', title: '', author: '', pageCount: 0), 
      ),
    );

    if (newBook != null) {
      await store.saveBook(newBook); 
      if (mounted && store.errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Livro "${newBook.title}" adicionado à estante.')),
        );
      }
    }
  }

  void _editBook(Book book, BookStore store) async {
    final updatedBook = await showDialog<Book>(
      context: context,
      // CRÍTICO: Uso direto do widget importado
      builder: (context) => BookEditDialog(book: book),
    );
    
    if (updatedBook != null) {
      await store.updateBook(updatedBook); 
      if (mounted && store.errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Livro "${updatedBook.title}" editado com sucesso.')),
        );
      }
    }
  }

  Future<bool> _confirmRemove(Book book, BookStore store) async {
    final shouldRemove = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      // CRÍTICO: Uso direto do widget importado
      builder: (context) => BookRemoveDialog(book: book),
    );

    if (shouldRemove == true) {
      try {
        await store.deleteBook(book.id); 
        if (mounted && store.errorMessage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Livro "${book.title}" removido permanentemente.')),
          );
        }
        return true; 
      } catch (e) {
         if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Erro ao remover o livro: $e')),
           );
         }
         return false; 
      }
    }
    return false; 
  }

  void _removeBook(Book book, BookStore store) {
    _confirmRemove(book, store); 
  }

  void _toggleReadingStatus(Book book, BookStore store) async {
     final updatedBook = book.copyWith(isReading: !book.isReading);
     await store.updateBook(updatedBook); 
  }
  
  // NOVO: Adiciona a opção de sincronização manual
  void _syncBooks(BookStore store) {
    store.loadBooks(forceSync: true);
  }
  
  // Método de Revisão de Onboarding (Usado no Drawer - Referenciado)
  void _revisitOnboarding() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkGreen,
        title: const Text('Revisar Termos', style: TextStyle(color: AppTheme.gold)),
        content: const Text(
          'Deseja realmente voltar ao início para revisar as políticas? Seu progresso será mantido, mas você deverá aceitar os termos novamente.', 
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCELAR', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.wineRed),
            child: const Text('CONFIRMAR'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await prefsService.setOnboardingCompleted(false);
      
      if (mounted) {
        // CORREÇÃO: Usa context.mounted e não apenas mounted na navegação
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.splash, 
          (route) => false,
        );
      }
    }
  }
  
  // CRÍTICO: Implementação estrutural do ImagePicker (REVERTIDA PARA MOCK)
  Future<File?> _pickImage(ImageSource source) async {
    
    // =========================================================================
    // NO SEU PROJETO REAL (NO CELULAR), DESCOMENTE ESTE CÓDIGO E COMENTE O MOCK ABAIXO
    
    final picker = ipk.ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source == ImageSource.camera ? ipk.ImageSource.camera : ipk.ImageSource.gallery,
      maxWidth: 512,      
      imageQuality: 80,   
    );
    
    if (pickedFile == null) return null;
    return File(pickedFile.path); 
    
    // =========================================================================

    
  }
  //


  // CRÍTICO: Lógica de Ação (Abre o Dialog e executa o Controller)
  void _showPhotoActionDialog(ProfileController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkGreen,
      builder: (context) {
        // Se a foto existir, adiciona a opção "Remover Foto"
        final hasPhoto = controller.photoPath != null;
        
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppTheme.gold),
              title: const Text('Tirar Foto', style: TextStyle(color: Colors.white)),
              onTap: () async {
                Navigator.pop(context);
                // CRÍTICO: Chamada à função real (ImageSource.camera)
                final File? image = await _pickImage(ImageSource.camera); 
                // CORREÇÃO: Usando `mounted`
                if (image != null && mounted) {
                  // Delega ao Controller, que salva e notifica a UI
                  await controller.setPhoto(image);
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Seleção de imagem cancelada.')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.image, color: AppTheme.gold),
              title: const Text('Escolher da Galeria', style: TextStyle(color: Colors.white)),
              onTap: () async {
                Navigator.pop(context);
                // CRÍTICO: Chamada à função real (ImageSource.gallery)
                final File? image = await _pickImage(ImageSource.gallery); 
                // CORREÇÃO: Usando `mounted`
                if (image != null && mounted) {
                  // Delega ao Controller, que salva e notifica a UI
                  await controller.setPhoto(image);
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Seleção de imagem cancelada.')),
                  );
                }
              },
            ),
            if (hasPhoto)
              ListTile(
                leading: const Icon(Icons.delete_forever, color: AppTheme.wineRed),
                title: const Text('Remover Foto', style: TextStyle(color: AppTheme.wineRed)),
                onTap: () async {
                  Navigator.pop(context);
                  // Delega ao Controller para apagar arquivo e metadado
                  await controller.removePhoto();
                  // CORREÇÃO: Usando `mounted`
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Foto de perfil removida com sucesso.')),
                    );
                  }
                },
              ),
            ListTile(
              title: const Text('Aviso de Privacidade', style: TextStyle(color: Colors.white70, fontSize: 12)),
              subtitle: const Text('Sua foto fica apenas neste dispositivo. Você pode remover quando quiser.', style: TextStyle(color: Colors.white54, fontSize: 10)),
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // CRÍTICO: Consome as Stores
    final store = context.watch<BookStore>();
    final profileController = context.watch<ProfileController>(); // NOVO
    
    // Constrói o widget CircleAvatar principal
    Widget profileAvatar() {
      // 1. Tenta usar a foto se houver e não estiver carregando
      if (profileController.photoPath != null && !profileController.isLoading) {
        // Exibe a foto do arquivo (FileImage)
        return CircleAvatar(
          radius: 40,
          backgroundColor: AppTheme.gold, // Borda
          // CRÍTICO: O FileImage vai falhar no web, mas no celular ele carrega a foto real.
          backgroundImage: FileImage(File(profileController.photoPath!)),
        );
      } else if (profileController.isLoading) {
        // 2. Exibe indicador se estiver carregando
        return const CircleAvatar(
          radius: 40,
          backgroundColor: AppTheme.gold,
          child: CircularProgressIndicator(color: AppTheme.darkGreen, strokeWidth: 2),
        );
      } else {
        // 3. Fallback para as iniciais
        return CircleAvatar(
          radius: 40,
          backgroundColor: AppTheme.gold,
          child: Text(
            profileController.getInitials(), // Usa o método do Controller
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.darkGreen),
          ),
        );
      }
    }
    
    // CRÍTICO: Wrapper para permitir o toque no avatar (A11Y Semantics/Tooltip)
    Widget avatarWithAction() {
      return Tooltip(
        message: profileController.photoPath != null ? 'Tocar para alterar/remover foto' : 'Tocar para adicionar foto',
        child: Semantics(
          label: 'Botão de edição de foto de perfil',
          button: true, // Indica que é um botão
          child: GestureDetector(
            onTap: () => _showPhotoActionDialog(profileController),
            child: Stack(
              children: [
                profileAvatar(),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.gold,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.darkGreen, width: 2),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: AppTheme.darkGreen,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Estante (Livraria do Duque)'),
        backgroundColor: AppTheme.darkGreen,
        foregroundColor: AppTheme.gold,
        actions: [
          // Botão de Sincronização Manual
          if (!store.isLoading) 
            IconButton(
              icon: const Icon(Icons.sync, color: AppTheme.gold),
              onPressed: () => _syncBooks(store),
            ),
        ],
      ),
      // Drawer (Com chamada para _revisitOnboarding)
      drawer: Drawer(
        backgroundColor: AppTheme.darkGreen,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // NOVO: DrawerHeader com Avatar do Usuário (Foto ou Iniciais)
            DrawerHeader(
              decoration: const BoxDecoration(color: AppTheme.darkGreen),
              // CRÍTICO: Adiciona Semantics label ao DrawerHeader
              child: Semantics(
                label: 'Informações do Perfil do Usuário',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // CORREÇÃO: Usando um espaçamento mais seguro para evitar overflow
                  // A altura do DrawerHeader é flexível até um limite, mas o Row não pode estourar.
                  children: [
                    avatarWithAction(), // CRÍTICO: Adicionado o Wrapper de Ação
                    // Removido SizedBox(height: 10)
                    Text(
                      profileController.userName,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      profileController.userEmail,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            // ... (DrawerHeader e outras opções)
            ListTile(
              leading: const Icon(Icons.menu_book, color: AppTheme.gold),
              title: const Text('Livros (Estante)', style: TextStyle(color: Colors.white70)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white70),
              title: const Text('Autores', style: TextStyle(color: Colors.white70)),
              onTap: () {
                Navigator.pop(context); // Fecha o Drawer
                // Ação: Navega para a nova tela de Autores
                Navigator.pushNamed(context, AppRoutes.authors); 
              },
            ),
             ListTile(
              leading: const Icon(Icons.star, color: Colors.white70),
              title: const Text('Avaliações', style: TextStyle(color: Colors.white70)),
              onTap: () {
                Navigator.pop(context); // Fecha o Drawer
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navegar para Relatório de Avaliações (Review)')),
                );
              },
            ),
            const Divider(color: AppTheme.gold),
            
            // Botão para revisar LGPD/Onboarding
            ListTile(
              leading: const Icon(Icons.policy, color: AppTheme.wineRed),
              title: const Text('Revisar Termos e Condições', style: TextStyle(color: AppTheme.wineRed)),
              onTap: () {
                Navigator.pop(context); // Fecha o Drawer
                _revisitOnboarding(); // Chama a função de navegação
              },
            ),
          ],
        ),
      ),
      
      // Corpo Principal (Chama o construtor da lista)
      body: _buildBookList(store), 
      
      floatingActionButton: FloatingActionButton(
        onPressed: store.isLoading ? null : () => _openCreateDialog(store), // Desabilita se estiver carregando
        backgroundColor: store.isLoading ? AppTheme.darkGreen.withOpacity(0.5) : AppTheme.gold,
        child: const Icon(Icons.add, color: AppTheme.darkGreen),
      ),
    );
  }
  
  // Lista de Livros (Recebe a Store como parâmetro)
  Widget _buildBookList(BookStore store) {
    if (store.isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.gold));
    }
    
    // Exibe erro se houver
    if (store.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppTheme.wineRed),
              const SizedBox(height: 16),
              Text(
                'Falha ao sincronizar:', 
                style: TextStyle(color: AppTheme.wineRed, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                store.errorMessage!, 
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _syncBooks(store),
                child: const Text('Tentar Sincronizar Novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (store.books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shelves, size: 64, color: AppTheme.gold),
            const SizedBox(height: 16),
            Text('Nenhum Livro Encontrado.', style: TextStyle(color: AppTheme.gold)),
            Text('Use o botão "+" para catalogar seu primeiro volume.', style: TextStyle(color: Colors.white70)),
          ],
        ),
      );
    }
    
    // CRÍTICO: O retorno final deve estar AQUI (ListView.builder)
    return ListView.builder(
      itemCount: store.books.length,
      itemBuilder: (context, index) {
        final book = store.books[index];
        // Envolve o ListTile com Dismissible para remoção por swipe
        return Dismissible(
          key: Key(book.id),
          direction: DismissDirection.endToStart, 
          // Feedback visual
          background: Container(
            color: AppTheme.wineRed, // Cor de remoção
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const Icon(Icons.delete_forever, color: Colors.white, size: 30),
          ),
          // Confirmação antes de descartar
          confirmDismiss: (direction) async {
            return await _confirmRemove(book, store); // Usa a Store
          },
          // Widget principal
          child: ListTile(
            // TOQUE LONGO: Abre o novo Diálogo de Ações 
            onLongPress: () => showBookActionsDialog(
              context: context,
              book: book,
              onEdit: () => _editBook(book, store), // Usa a Store
              onRemove: () => _removeBook(book, store), // Usa a Store
            ),
            // TOQUE CURTO: Abre o Diálogo de Detalhes 
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => BookDetailDialog(
                  book: book, 
                  // CRÍTICO: Passando as funções para o Dialog usar a Store
                  onEdit: (b) => _editBook(b, store), 
                  onRemove: (b) => _removeBook(b, store), 
                ),
              );
            },
            leading: IconButton(
               icon: Icon(book.isReading ? Icons.auto_stories : Icons.book, 
                  color: book.isReading ? AppTheme.wineRed : AppTheme.gold),
               onPressed: () => _toggleReadingStatus(book, store), // Usa a Store
            ),
            title: Text(book.title, style: const TextStyle(color: Colors.white)),
            subtitle: Text('${book.author} | ${book.pageCount} páginas', style: const TextStyle(color: Colors.white70)),
            
            // Ícone de Lápis (Edição)
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: AppTheme.gold, size: 20),
              onPressed: () => _editBook(book, store), // Usa a Store
            ),
          ),
        );
      },
    );
  }
}