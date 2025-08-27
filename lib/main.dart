import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';


// --- Services ---
// A simple service to manage in-memory user authentication.
class AuthService with ChangeNotifier {
  String? _user;

  String? get user => _user;

  Future<void> signInAnonymously() async {
    // Generate a new unique ID to simulate a user signing in.
    _user = const Uuid().v4();
    notifyListeners();
  }

  Future<void> signOut() async {
    _user = null;
    notifyListeners();
  }
}

// A singleton service to manage all in-memory data for the app.
class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final _itemsController = StreamController<List<ItemModel>>.broadcast();
  final _bookingsController = StreamController<List<BookingModel>>.broadcast();
  final _messagesController = StreamController<List<MessageModel>>.broadcast();

  final List<ItemModel> _items = [
    ItemModel(
      id: const Uuid().v4(),
      ownerId: "mock-user-1",
      title: "Lawn Mower",
      description: "A reliable gas lawn mower, great for small to medium-sized yards.",
      imageUrl: "https://placehold.co/600x400/222222/FFFFFF?text=Lawn+Mower",
      category: "Gardening",
      deposit: 50,
      pricePerDay: 20,
    ),
    ItemModel(
      id: const Uuid().v4(),
      ownerId: "mock-user-2",
      title: "Concrete Mixer",
      description: "Heavy-duty concrete mixer for your next DIY project.",
      imageUrl: "https://placehold.co/600x400/222222/FFFFFF?text=Concrete+Mixer",
      category: "Construction",
      deposit: 100,
      pricePerDay: 45,
    ),
    ItemModel(
      id: const Uuid().v4(),
      ownerId: "mock-user-1",
      title: "Pressure Washer",
      description: "Powerful pressure washer for cleaning driveways and patios.",
      imageUrl: "https://placehold.co/600x400/222222/FFFFFF?text=Pressure+Washer",
      category: "General",
      deposit: 75,
      pricePerDay: 30,
    ),
  ];

  final List<BookingModel> _bookings = [];
  final Map<String, List<MessageModel>> _messages = {};

  Stream<List<ItemModel>> getItems() => _itemsController.stream;
  Stream<List<ItemModel>> getItemsForUser(String userId) {
    return _itemsController.stream
        .map((items) => items.where((item) => item.ownerId == userId).toList());
  }

  Stream<List<BookingModel>> getBookingsForUser(String userId) {
    return _bookingsController.stream
        .map((bookings) => bookings.where((b) => b.userId == userId).toList());
  }

  Stream<List<MessageModel>> getMessages(String chatRoomId) {
    if (!_messages.containsKey(chatRoomId)) {
      _messages[chatRoomId] = [];
    }
    return _messagesController.stream
        .map((allMessages) => _messages[chatRoomId]!.toList());
  }

  void addItem(ItemModel item) {
    _items.add(item);
    _itemsController.add(_items);
  }

  void requestBooking(BookingModel booking) {
    _bookings.add(booking);
    _bookingsController.add(_bookings);
  }

  void sendMessage(String chatRoomId, MessageModel message) {
    if (!_messages.containsKey(chatRoomId)) {
      _messages[chatRoomId] = [];
    }
    _messages[chatRoomId]!.add(message);
    _messagesController.add(_messages.values.expand((x) => x).toList());
  }

  ItemModel? getItemById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  void init() {
    _itemsController.add(_items);
    _bookingsController.add(_bookings);
    _messagesController.add(_messages.values.expand((x) => x).toList());
  }
}

// --- Models ---
class ItemModel {
  final String id;
  final String ownerId;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final int deposit;
  final int pricePerDay;

  ItemModel({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.deposit,
    required this.pricePerDay,
  });
}

class BookingModel {
  final String id;
  final String itemId;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  BookingModel({
    required this.id,
    required this.itemId,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.status,
  });
}

class MessageModel {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });
}

// --- Screens ---


class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.handyman, size: 100, color: Colors.orangeAccent),
              const SizedBox(height: 20),
              const Text(
                "Neighbour Tool Lending",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                "Borrow and lend tools with your community.",
                style: TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ElevatedButton(
                  onPressed: () => auth.signInAnonymously(),
                  child: const Text("Continue as Guest"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    const HomeScreen(),
    const MyToolsScreen(),
    const MyBookingsScreen(),
    const ProfileScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.handyman), label: 'My Tools'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'My Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = DataService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Tools"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ItemModel>>(
        stream: dataService.getItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No tools available yet."));
          }

          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final item = items[i];
              return ItemCard(
                item: item,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ItemDetailScreen(item: item)),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const AddItemScreen()));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _depositController = TextEditingController();
  final _priceController = TextEditingController();
  String _category = "General";

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _depositController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final auth = Provider.of<AuthService>(context, listen: false);
    final dataService = DataService();

    if (auth.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be signed in to add an item.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    final newItem = ItemModel(
      id: const Uuid().v4(),
      ownerId: auth.user!,
      title: _titleController.text,
      description: _descController.text,
      imageUrl: "https://placehold.co/600x400/222222/FFFFFF?text=Placeholder",
      category: _category,
      deposit: int.tryParse(_depositController.text) ?? 0,
      pricePerDay: int.tryParse(_priceController.text) ?? 0,
    );

    dataService.addItem(newItem);

    setState(() => _isLoading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Tool")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomInput(
                controller: _titleController,
                labelText: "Tool Title",
                validator: (v) => v!.isEmpty ? "Enter a title" : null,
              ),
              const SizedBox(height: 10),
              CustomInput(
                controller: _descController,
                labelText: "Description",
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              CustomInput(
                controller: _depositController,
                labelText: "Deposit Amount (SAR)",
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Enter deposit amount" : null,
              ),
              const SizedBox(height: 10),
              CustomInput(
                controller: _priceController,
                labelText: "Price Per Day (SAR)",
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Enter price per day" : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: "Category"),
                items: ["General", "Gardening", "Construction", "Party"].map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) => setState(() => _category = val! as String),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Add Tool",
                onPressed: _saveItem,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemDetailScreen extends StatefulWidget {
  final ItemModel item;
  const ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  bool _loading = false;

  Future<void> _pickDate({required bool start}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (start) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _requestBooking() async {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both start and end dates.')),
      );
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End date must be after start date.')),
      );
      return;
    }

    setState(() => _loading = true);
    final auth = Provider.of<AuthService>(context, listen: false);
    final dataService = DataService();

    if (auth.user == null) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be signed in to request a booking.')),
      );
      setState(() => _loading = false);
      return;
    }
    
    final newBooking = BookingModel(
      id: const Uuid().v4(),
      itemId: widget.item.id,
      userId: auth.user!,
      startDate: _startDate!,
      endDate: _endDate!,
      status: "requested",
    );

    dataService.requestBooking(newBooking);

    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking requested successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.item.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              widget.item.imageUrl,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 250),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.item.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text("Category: ${widget.item.category}"),
                  Text("Price: ${widget.item.pricePerDay} SAR/day"),
                  Text("Deposit: ${widget.item.deposit} SAR"),
                  const SizedBox(height: 24),
                  const Text("Request a booking:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _pickDate(start: true),
                          child: Text(_startDate == null
                              ? "Start Date"
                              : _startDate!.toString().split(" ")[0]),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _pickDate(start: false),
                          child: Text(_endDate == null
                              ? "End Date"
                              : _endDate!.toString().split(" ")[0]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _loading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _requestBooking,
                          child: const Text("Request Booking"),
                        ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            chatRoomId: widget.item.id,
                            recipientId: widget.item.ownerId,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text("Message Owner"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyToolsScreen extends StatelessWidget {
  const MyToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = DataService();
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("My Tools")),
      body: StreamBuilder<List<ItemModel>>(
        stream: dataService.getItemsForUser(auth.user!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("You have not added any tools yet."));
          }

          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final item = items[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${item.pricePerDay} SAR/day"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to a screen to view and manage bookings for this item.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Manage bookings for this tool.')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final dataService = DataService();

    return Scaffold(
      appBar: AppBar(title: const Text("My Bookings")),
      body: StreamBuilder<List<BookingModel>>(
        stream: dataService.getBookingsForUser(auth.user!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No bookings yet."));
          }
          
          final bookings = snapshot.data!;
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (_, i) {
              final b = bookings[i];
              final item = dataService.getItemById(b.itemId);
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: item != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(item.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                        )
                      : const Icon(Icons.help_outline, size: 60),
                  title: Text(item?.title ?? "Unknown Item"),
                  subtitle: Text("${b.startDate.toString().split(" ")[0]} → ${b.endDate.toString().split(" ")[0]}"),
                  trailing: Chip(
                    label: Text(b.status.toUpperCase()),
                    backgroundColor: b.status == "requested" ? Colors.yellow.shade900 : Colors.green.shade900,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Profile",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("User ID:"),
                    const SizedBox(height: 8),
                    Text(
                      auth.user!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement logout functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a guest user, no logout needed.')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final String recipientId;

  const ChatScreen({
    super.key,
    required this.chatRoomId,
    required this.recipientId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _dataService = DataService();
  final _uuid = const Uuid();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    final auth = Provider.of<AuthService>(context, listen: false);
    if (auth.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be signed in to chat.')),
      );
      return;
    }

    final newMessage = MessageModel(
      id: _uuid.v4(),
      senderId: auth.user!,
      text: _messageController.text,
      timestamp: DateTime.now(),
    );

    _dataService.sendMessage(widget.chatRoomId, newMessage);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    if (auth.user == null) {
      return const Center(child: Text("Please sign in to view this chat."));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: _dataService.getMessages(widget.chatRoomId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Start the conversation!"));
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (_, i) {
                    final message = messages[i];
                    final isMe = message.senderId == auth.user;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.orangeAccent.withOpacity(0.8) : Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          message.text,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomInput(
                    controller: _messageController,
                    labelText: "Type a message...",
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                  color: Colors.orangeAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Widgets ---
class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomInput({
    super.key,
    required this.controller,
    required this.labelText,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(text),
    );
  }
}

class ItemCard extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onTap;

  const ItemCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 80),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${item.pricePerDay} SAR/day",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Deposit: ${item.deposit} SAR",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return auth.user == null ? const OnboardingScreen() : const MainScreen();
  }
}

void main() {
  DataService().init(); // Initialize the mock data service
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const Tooly(),
    ),
  );
}

class Tooly extends StatelessWidget {
  const Tooly({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neighbour Tool Lending',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent, brightness: Brightness.dark),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          filled: true,
          fillColor: Colors.white10,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.orangeAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}
