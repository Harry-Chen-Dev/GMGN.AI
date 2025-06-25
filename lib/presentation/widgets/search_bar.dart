import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';

class CustomSearchBar extends StatefulWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool readOnly;

  const CustomSearchBar({
    super.key,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.readOnly = false,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _isFocused ? AppColors.primary : AppColors.borderColor,
          width: _isFocused ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Search icon
          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: Icon(
              Icons.search,
              color: _isFocused ? AppColors.primary : AppColors.textSecondary,
              size: 20.sp,
            ),
          ),
          
          // Text field
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              readOnly: widget.readOnly,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              onTap: widget.onTap,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText ?? '搜索代币或粘贴合约地址',
                hintStyle: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textTertiary,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 16.h,
                ),
              ),
            ),
          ),
          
          // Quick actions
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // QR scan button
              GestureDetector(
                onTap: _showQRScanner,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  child: Icon(
                    Icons.qr_code_scanner,
                    color: AppColors.textSecondary,
                    size: 20.sp,
                  ),
                ),
              ),
              
              // Paste button
              GestureDetector(
                onTap: _pasteFromClipboard,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  margin: EdgeInsets.only(right: 8.w),
                  child: Icon(
                    Icons.content_paste,
                    color: AppColors.textSecondary,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showQRScanner() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        height: 300.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_scanner,
              size: 64.sp,
              color: AppColors.primary,
            ),
            
            SizedBox(height: 24.h),
            
            Text(
              '扫描二维码',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            
            SizedBox(height: 8.h),
            
            Text(
              '扫描包含代币合约地址的二维码',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 24.h),
            
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement QR scanner
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('二维码扫描功能即将推出'),
                    backgroundColor: AppColors.cardBackground,
                  ),
                );
              },
              child: Text('打开相机'),
            ),
          ],
        ),
      ),
    );
  }

  void _pasteFromClipboard() async {
    // TODO: Implement clipboard paste
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('剪贴板功能即将推出'),
        backgroundColor: AppColors.cardBackground,
      ),
    );
  }
}