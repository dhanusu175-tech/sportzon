import 'package:flutter/material.dart';

void main() {
  runApp(const SportzonApp());
}

class Product {
  final int id;
  final String name;
  final String category;
  final int price;
  final int oldPrice;
  final double rating;
  final IconData icon;
  final Color color;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.icon,
    required this.color,
    required this.description,
  });

  int get discount => ((oldPrice - price) / oldPrice * 100).round();
}

const demoProducts = [
  Product(
    id: 1,
    name: 'Pro Cricket Bat',
    category: 'Cricket',
    price: 2499,
    oldPrice: 3999,
    rating: 4.5,
    icon: Icons.sports_cricket,
    color: Color(0xFFFFE0B2),
    description: 'Lightweight cricket bat for practice and matches.',
  ),
  Product(
    id: 2,
    name: 'Football',
    category: 'Football',
    price: 899,
    oldPrice: 1499,
    rating: 4.4,
    icon: Icons.sports_soccer,
    color: Color(0xFFC8E6C9),
    description: 'Durable football suitable for outdoor play.',
  ),
  Product(
    id: 3,
    name: 'Running Shoes',
    category: 'Running',
    price: 1999,
    oldPrice: 2999,
    rating: 4.6,
    icon: Icons.directions_run,
    color: Color(0xFFBBDEFB),
    description: 'Comfortable running shoes with cushioned support.',
  ),
  Product(
    id: 4,
    name: 'Gym Dumbbells',
    category: 'Gym',
    price: 1299,
    oldPrice: 1999,
    rating: 4.3,
    icon: Icons.fitness_center,
    color: Color(0xFFE1BEE7),
    description: 'Strength training dumbbells for home workouts.',
  ),
  Product(
    id: 5,
    name: 'Badminton Racket',
    category: 'Badminton',
    price: 1499,
    oldPrice: 2499,
    rating: 4.5,
    icon: Icons.sports_tennis,
    color: Color(0xFFFFCDD2),
    description: 'Lightweight racket for recreational badminton.',
  ),
  Product(
    id: 6,
    name: 'Sports Jersey',
    category: 'Clothing',
    price: 699,
    oldPrice: 1199,
    rating: 4.2,
    icon: Icons.checkroom,
    color: Color(0xFFFFF9C4),
    description: 'Breathable sports jersey for everyday training.',
  ),
  Product(
    id: 7,
    name: 'Basketball',
    category: 'Basketball',
    price: 999,
    oldPrice: 1599,
    rating: 4.4,
    icon: Icons.sports_basketball,
    color: Color(0xFFFFCCBC),
    description: 'Basketball with a durable grip surface.',
  ),
  Product(
    id: 8,
    name: 'Sports Water Bottle',
    category: 'Accessories',
    price: 399,
    oldPrice: 699,
    rating: 4.1,
    icon: Icons.water_drop,
    color: Color(0xFFB2DFDB),
    description: 'Reusable bottle to keep you hydrated during sports.',
  ),
];

class SportzonApp extends StatelessWidget {
  const SportzonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPORTZON',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1769FF),
        ),
        fontFamily: 'Arial',
      ),
      home: const ShopHome(),
    );
  }
}

class ShopHome extends StatefulWidget {
  const ShopHome({super.key});

  @override
  State<ShopHome> createState() => _ShopHomeState();
}

class _ShopHomeState extends State<ShopHome> {
  int selectedTab = 0;
  String selectedCategory = 'All';
  String searchText = '';

  final Map<int, int> cart = {};
  final Set<int> wishlist = {};

  int get cartCount => cart.values.fold(0, (a, b) => a + b);

  int get cartTotal {
    int total = 0;
    for (final product in demoProducts) {
      total += product.price * (cart[product.id] ?? 0);
    }
    return total;
  }

  List<Product> get filteredProducts {
    return demoProducts.where((product) {
      final categoryMatch = selectedCategory == 'All' ||
          product.category == selectedCategory;

      final searchMatch = product.name
          .toLowerCase()
          .contains(searchText.toLowerCase());

      return categoryMatch && searchMatch;
    }).toList();
  }

  void addToCart(Product product) {
    setState(() {
      cart[product.id] = (cart[product.id] ?? 0) + 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void changeQuantity(Product product, int amount) {
    setState(() {
      final updated = (cart[product.id] ?? 0) + amount;
      if (updated <= 0) {
        cart.remove(product.id);
      } else {
        cart[product.id] = updated;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      homePage(),
      categoriesPage(),
      cartPage(),
      routinePage(),
      profilePage(),
    ];

    return Scaffold(
      body: SafeArea(child: pages[selectedTab]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (index) {
          setState(() => selectedTab = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Routine',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget homePage() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          decoration: const BoxDecoration(
            color: Color(0xFF1769FF),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.sports_soccer,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'SPORTZON',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => selectedTab = 2),
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '$cartCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                onChanged: (value) => setState(() => searchText = value),
                decoration: InputDecoration(
                  hintText: 'Search sports products...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF071A42), Color(0xFF1769FF)],
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'SPORTS SEASON',
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'GEAR UP.\nPLAY BETTER.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Amazing deals on sports essentials!',
                      style: TextStyle(color: Colors.yellowAccent),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Shop by Category',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    'All',
                    'Cricket',
                    'Football',
                    'Running',
                    'Gym',
                    'Badminton',
                    'Basketball',
                    'Clothing',
                    'Accessories',
                  ].map((category) {
                    final selected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: selected,
                        onSelected: (_) {
                          setState(() => selectedCategory = category);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Best Deals',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedCategory = 'All';
                        searchText = '';
                      });
                    },
                    child: const Text('View all'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth > 700 ? 4 : 2;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: constraints.maxWidth > 700 ? 0.78 : 0.68,
                    ),
                    itemBuilder: (context, index) {
                      return productCard(filteredProducts[index]);
                    },
                  );
                },
              ),
              if (filteredProducts.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('No products found. Try another search.'),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget productCard(Product product) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailsPage(
            product: product,
            onAdd: () => addToCart(product),
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8ECF2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: product.color,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Icon(
                      product.icon,
                      size: 75,
                      color: const Color(0xFF26364D),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${product.discount}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (wishlist.contains(product.id)) {
                            wishlist.remove(product.id);
                          } else {
                            wishlist.add(product.id);
                          }
                        });
                      },
                      icon: Icon(
                        wishlist.contains(product.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: wishlist.contains(product.id)
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '₹${product.price}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 15),
                      Text(' ${product.rating}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => addToCart(product),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD814),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text(
                        'ADD TO CART',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoriesPage() {
    final categories = [
      'Cricket',
      'Football',
      'Running',
      'Gym',
      'Badminton',
      'Basketball',
      'Clothing',
      'Accessories',
    ];

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'Sports Categories',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        ...categories.map((category) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.sports, color: Color(0xFF1769FF)),
              title: Text(category),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                setState(() {
                  selectedCategory = category;
                  selectedTab = 0;
                });
              },
            ),
          );
        }),
      ],
    );
  }

  Widget cartPage() {
    final items = demoProducts
        .where((product) => (cart[product.id] ?? 0) > 0)
        .toList();

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          color: const Color(0xFF1769FF),
          child: const Text(
            'My Shopping Cart',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 75),
                      SizedBox(height: 10),
                      Text('Your cart is empty', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ...items.map((product) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: product.color,
                            child: Icon(product.icon),
                          ),
                          title: Text(product.name),
                          subtitle: Text('₹${product.price}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => changeQuantity(product, -1),
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                              Text('${cart[product.id]}'),
                              IconButton(
                                onPressed: () => changeQuantity(product, 1),
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 15),
                    Text(
                      'Total: ₹$cartTotal',
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => cart.clear());
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Demo Order Placed'),
                            content: const Text(
                              'This is an offline demo. No real order or payment was made.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('PLACE DEMO ORDER'),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget routinePage() {
    final routine = [
      ['6:00 AM', 'Morning Walk', 'Walk for 10–15 minutes.'],
      ['6:15 AM', 'Warm-up', 'Gentle stretches for 5 minutes.'],
      ['6:20 AM', 'Workout', 'Try light exercise or bodyweight training.'],
      ['6:40 AM', 'Sports Practice', 'Practice your favorite sport.'],
      ['7:00 AM', 'Cool Down', 'Stretch and drink water.'],
    ];

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'Daily Fitness Routine',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        ...routine.map(
          (item) => Card(
            child: ListTile(
              leading: const Icon(Icons.fitness_center, color: Color(0xFF1769FF)),
              title: Text(item[1]),
              subtitle: Text(item[2]),
              trailing: Text(
                item[0],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Tip: Start slowly, stay hydrated, and take rest when needed.',
        ),
      ],
    );
  }

  Widget profilePage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 20),
        const CircleAvatar(
          radius: 50,
          backgroundColor: Color(0xFF1769FF),
          child: Icon(Icons.person, color: Colors.white, size: 55),
        ),
        const SizedBox(height: 15),
        const Center(
          child: Text(
            'SPORTZON Customer',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 25),
        const Card(
          child: ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('My Orders'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Wishlist'),
            trailing: Text('${wishlist.length} items'),
            onTap: () {
              final names = demoProducts
                  .where((product) => wishlist.contains(product.id))
                  .map((product) => product.name)
                  .join(', ');

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    names.isEmpty ? 'Wishlist is empty' : names,
                  ),
                ),
              );
            },
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Help & Support'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
      ],
    );
  }
}

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const ProductDetailsPage({
    super.key,
    required this.product,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: product.color,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(product.icon, size: 120),
          ),
          const SizedBox(height: 20),
          Text(
            product.name,
            style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '₹${product.price}',
            style: const TextStyle(
              fontSize: 25,
              color: Color(0xFF1769FF),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '₹${product.oldPrice}',
            style: const TextStyle(
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          Text('${product.discount}% discount'),
          const SizedBox(height: 20),
          const Text(
            'Product Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(product.description),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: onAdd,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD814),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.all(16),
            ),
            child: const Text('ADD TO CART'),
          ),
        ],
      ),
    );
  }
} 

  