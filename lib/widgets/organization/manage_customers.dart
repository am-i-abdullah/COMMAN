import 'package:comman/api/data_fetching/get_customers.dart';
import 'package:comman/pages/customer_dashboard.dart';
import 'package:comman/provider/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageCustomers extends ConsumerStatefulWidget {
  const ManageCustomers({super.key, required this.id});
  final String id;
  @override
  ConsumerState<ManageCustomers> createState() => _ManageCustomersState();
}

class _ManageCustomersState extends ConsumerState<ManageCustomers> {
  var customers;
  var content;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    content = const Center(child: CircularProgressIndicator());
    customers = await getCustomers(
        token: ref.read(tokenProvider.state).state!, id: widget.id);

    if (customers.toString() == '[]') {
      content = const Center(
        child: Text(
          "Dial 0320-0094995, \nGet your business promoted, \nyou'll see a list here!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 19),
        ),
      );
    }

    setState(() {});

    print(customers);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GridView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: width > 600 ? 2 : 1,
        childAspectRatio: width < 600 ? 2 : 3,
        crossAxisSpacing: 0,
        mainAxisSpacing: 12,
      ),
      children: (customers != null && customers.isNotEmpty)
          ? [
              for (final customer in customers)
                CustomerCard(
                  width: width,
                  firstname: customer['first_name'],
                  lastname: customer['last_name'],
                  date: customer['visit_date'],
                  contact: customer['contact_number'],
                  organizationId: widget.id.toString(),
                  customerId: customer['id'],
                )
            ]
          : [content],
    );
  }
}

class CustomerCard extends StatelessWidget {
  const CustomerCard({
    super.key,
    required this.width,
    required this.firstname,
    required this.lastname,
    required this.date,
    required this.contact,
    required this.organizationId,
    required this.customerId,
  });

  final double width;
  final String firstname;
  final String lastname;
  final String date;
  final int contact;
  final String organizationId;
  final int customerId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      borderRadius: const BorderRadius.all(Radius.circular(25)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerDashboard(
              organizationId: organizationId,
              customerId: customerId,
              firstname: firstname,
              lastname: lastname,
            ),
          ),
        );
      },
      child: Card(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white12
            : Colors.white54,
        shadowColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$firstname $lastname',
                style: TextStyle(
                  fontSize: width < 600 ? 20 : 45,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Visit: $date',
                style: TextStyle(fontSize: width < 600 ? 15 : 25),
              ),
              Text(
                contact.toString(),
                style: TextStyle(
                  fontSize: width < 600 ? 17 : 35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
