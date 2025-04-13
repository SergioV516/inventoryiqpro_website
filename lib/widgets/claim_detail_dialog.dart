// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:inventory_iq_pro/models/claim.dart';

// class ClaimDetailDialog extends StatefulWidget {
//   final Claim claim;
  
//   const ClaimDetailDialog({
//     Key? key,
//     required this.claim,
//   }) : super(key: key);

//   @override
//   _ClaimDetailDialogState createState() => _ClaimDetailDialogState();
// }

// class _ClaimDetailDialogState extends State<ClaimDetailDialog> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
  
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//   }
  
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     final claim = widget.claim;
    
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.8,
//         height: MediaQuery.of(context).size.height * 0.8,
//         padding: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildDialogHeader(claim),
//             const SizedBox(height: 24),
//             _buildClaimSummary(claim),
//             const SizedBox(height: 24),
//             TabBar(
//               controller: _tabController,
//               labelColor: const Color(0xFF1E2A3A),
//               unselectedLabelColor: Colors.grey,
//               indicatorColor: const Color(0xFF1E2A3A),
//               tabs: const [
//                 Tab(text: 'Items', icon: Icon(Icons.inventory_2)),
//                 Tab(text: 'Details', icon: Icon(Icons.description)),
//                 Tab(text: 'Documents', icon: Icon(Icons.folder)),
//                 Tab(text: 'History', icon: Icon(Icons.history)),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   _buildItemsTab(claim),
//                   _buildDetailsTab(claim),
//                   _buildDocumentsTab(claim),
//                   _buildHistoryTab(claim),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 OutlinedButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Close'),
//                 ),
//                 const SizedBox(width: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Navigate to edit page
//                     Navigator.of(context).pop();
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Edit functionality to be implemented')),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF1E2A3A),
//                     foregroundColor: Colors.white,
//                   ),
//                   child: const Text('Edit Claim'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
  
//   Widget _buildDialogHeader(Claim claim) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             const Icon(Icons.insert_drive_file, size: 32),
//             const SizedBox(width: 16),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Claim ${claim.id}',
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   'Submitted on ${DateFormat('MMMM d, yyyy').format(claim.dateSubmitted)}',
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         IconButton(
//           icon: const Icon(Icons.close),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ],
//     );
//   }
  
//   Widget _buildClaimSummary(Claim claim) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[200]!),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildInfoRow('Client', claim.clientName),
//                 const SizedBox(height: 8),
//                 _buildInfoRow('Policy Number', claim.policyNumber),
//                 const SizedBox(height: 8),
//                 _buildInfoRow('Claim Type', claim.claimType),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildInfoRow('Status', claim.status, isStatus: true),
//                 const SizedBox(height: 8),
//                 _buildInfoRow('Total Value', '\$${NumberFormat('#,##0.00').format(claim.totalValue)}'),
//                 const SizedBox(height: 8),
//                 _buildInfoRow('Items Claimed', '${claim.items.length}'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           width: 120,
//           child: Text(
//             '$label:',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[700],
//             ),
//           ),
//         ),
//         Expanded(
//           child: isStatus
//               ? _buildStatusChip(value)
//               : Text(
//                   value,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//         ),
//       ],
//     );
//   }
  
//   Widget _buildStatusChip(String status) {
//     Color color;
//     IconData icon;
    
//     switch (status) {
//       case 'Submitted':
//         color = Colors.blue;
//         icon = Icons.add_circle;
//         break;
//       case 'Reviewed':
//         color = Colors.orange;
//         icon = Icons.search;
//         break;
//       case 'Approved':
//         color = Colors.green;
//         icon = Icons.check_circle;
//         break;
//       case 'Released':
//         color = Colors.purple;
//         icon = Icons.done_all;
//         break;
//       default:
//         color = Colors.grey;
//         icon = Icons.info;
//     }
    
//     return Chip(
//       avatar: Icon(icon, color: color, size: 16),
//       label: Text(
//         status,
//         style: TextStyle(color: color, fontSize: 12),
//       ),
//       backgroundColor: color.withOpacity(0.1),
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
//       visualDensity: VisualDensity.compact,
//     );
//   }
  
//   Widget _buildItemsTab(Claim claim) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Claimed Items',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           DataTable(
//             columnSpacing: 20,
//             headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
//             columns: const [
//               DataColumn(label: Text('Item')),
//               DataColumn(label: Text('Category')),
//               DataColumn(label: Text('Value'), numeric: true),
//             ],
//             rows: claim.items.map((item) {
//               return DataRow(
//                 cells: [
//                   DataCell(Text(item.name)),
//                   DataCell(Text(item.category)),
//                   DataCell(Text('\${NumberFormat('#,##0.00').format(item.value)}')),
//                 ],
//               );
//             }).toList(),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Total Claimed',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 '\${NumberFormat('#,##0.00').format(claim.totalValue)}',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildDetailsTab(Claim claim) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Claim Description',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.grey[50],
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.grey[200]!),
//             ),
//             child: Text(claim.description),
//           ),
//           const SizedBox(height: 24),
//           const Text(
//             'Claim Process Timeline',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
          
//           // Timeline steps
//           _buildTimelineStep(
//             'Claim Submitted',
//             DateFormat('MMM dd, yyyy').format(claim.dateSubmitted),
//             Colors.blue,
//             isCompleted: true,
//           ),
//           _buildTimelineConnector(isCompleted: claim.status != 'Submitted'),
//           _buildTimelineStep(
//             'Claim Reviewed',
//             claim.status == 'Submitted' ? 'Pending' : 'March 15, 2023',
//             Colors.orange,
//             isCompleted: claim.status != 'Submitted',
//           ),
//           _buildTimelineConnector(isCompleted: claim.status == 'Approved' || claim.status == 'Released'),
//           _buildTimelineStep(
//             'Claim Approved',
//             claim.status == 'Submitted' || claim.status == 'Reviewed' ? 'Pending' : 'March 22, 2023',
//             Colors.green,
//             isCompleted: claim.status == 'Approved' || claim.status == 'Released',
//           ),
//           _buildTimelineConnector(isCompleted: claim.status == 'Released'),
//           _buildTimelineStep(
//             'Payment Released',
//             claim.status == 'Released' ? 'April 5, 2023' : 'Pending',
//             Colors.purple,
//             isCompleted: claim.status == 'Released',
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildTimelineStep(String title, String date, Color color, {required bool isCompleted}) {
//     return Row(
//       children: [
//         Container(
//           width: 24,
//           height: 24,
//           decoration: BoxDecoration(
//             color: isCompleted ? color : Colors.grey[300],
//             shape: BoxShape.circle,
//           ),
//           child: isCompleted
//               ? const Icon(
//                   Icons.check,
//                   color: Colors.white,
//                   size: 16,
//                 )
//               : null,
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: isCompleted ? color : Colors.grey,
//                 ),
//               ),
//               Text(
//                 date,
//                 style: TextStyle(
//                   color: isCompleted ? Colors.black : Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
  
//   Widget _buildTimelineConnector({required bool isCompleted}) {
//     return Container(
//       margin: const EdgeInsets.only(left: 11),
//       width: 2,
//       height: 24,
//       color: isCompleted ? Colors.green : Colors.grey[300],
//     );
//   }
  
//   Widget _buildDocumentsTab(Claim claim) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Attached Documents',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           ListView.separated(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: claim.attachments.length,
//             separatorBuilder: (context, index) => const Divider(),
//             itemBuilder: (context, index) {
//               final attachment = claim.attachments[index];
//               IconData icon;
              
//               if (attachment.endsWith('.pdf')) {
//                 icon = Icons.picture_as_pdf;
//               } else if (attachment.endsWith('.jpg') || attachment.endsWith('.png')) {
//                 icon = Icons.image;
//               } else if (attachment.endsWith('.zip')) {
//                 icon = Icons.folder_zip;
//               } else if (attachment.endsWith('.xlsx') || attachment.endsWith('.xls')) {
//                 icon = Icons.table_chart;
//               } else {
//                 icon = Icons.insert_drive_file;
//               }
              
//               return ListTile(
//                 leading: Icon(icon, color: const Color(0xFF1E2A3A)),
//                 title: Text(attachment),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.remove_red_eye),
//                       tooltip: 'View Document',
//                       onPressed: () {
//                         // View document functionality
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Viewing $attachment')),
//                         );
//                       },
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.download),
//                       tooltip: 'Download Document',
//                       onPressed: () {
//                         // Download document functionality
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Downloading $attachment')),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton.icon(
//             onPressed: () {
//               // Add document functionality
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Add document functionality to be implemented')),
//               );
//             },
//             icon: const Icon(Icons.upload_file),
//             label: const Text('Upload New Document'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF1E2A3A),
//               foregroundColor: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildHistoryTab(Claim claim) {
//     // Mock history data
//     final historyEvents = [
//       {
//         'timestamp': DateTime(2023, 6, 15, 10, 32),
//         'user': 'John Smith',
//         'action': 'Claim Submitted',
//         'details': 'Initial claim submitted for ${claim.items.length} items totaling \${NumberFormat('#,##0.00').format(claim.totalValue)}.',
//       },
//       {
//         'timestamp': DateTime(2023, 6, 15, 14, 45),
//         'user': 'System',
//         'action': 'Documents Verified',
//         'details': 'Automated document verification complete.',
//       },
//       {
//         'timestamp': DateTime(2023, 6, 16, 9, 20),
//         'user': 'Sarah Johnson',
//         'action': 'Claim Assigned',
//         'details': 'Claim assigned to claims adjuster.',
//       },
//       if (claim.status != 'Submitted') {
//         'timestamp': DateTime(2023, 6, 18, 11, 15),
//         'user': 'Michael Brown',
//         'action': 'Claim Reviewed',
//         'details': 'Initial review completed. Waiting for approval.',
//       },
//       if (claim.status == 'Approved' || claim.status == 'Released') {
//         'timestamp': DateTime(2023, 6, 22, 15, 30),
//         'user': 'Jennifer Davis',
//         'action': 'Claim Approved',
//         'details': 'Claim approved for payment.',
//       },
//       if (claim.status == 'Released') {
//         'timestamp': DateTime(2023, 7, 1, 10, 0),
//         'user': 'System',
//         'action': 'Payment Processed',
//         'details': 'Payment of \${NumberFormat('#,##0.00').format(claim.totalValue)} processed.',
//       },
//     ];
    
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Claim History',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: historyEvents.length,
//             itemBuilder: (context, index) {
//               final event = historyEvents[index];
//               return _buildHistoryEvent(
//                 event['timestamp'] as DateTime,
//                 event['user'] as String,
//                 event['action'] as String,
//                 event['details'] as String,
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildHistoryEvent(DateTime timestamp, String user, String action, String details) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 DateFormat('MMM dd').format(timestamp),
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 DateFormat('hh:mm a').format(timestamp),
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[600],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(width: 16),
//           Container(
//             width: 12,
//             height: 12,
//             margin: const EdgeInsets.only(top: 4),
//             decoration: BoxDecoration(
//               color: const Color(0xFF1E2A3A),
//               shape: BoxShape.circle,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       action,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'By: $user',
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Text(details),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }