import 'package:flutter/material.dart';
import 'package:storage_space/storage_space.dart';

class StorageCard extends StatelessWidget {
  const StorageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFFF2F4F7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text(
            '저장 공간',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 30),
          _StorageWidget(),
        ]),
      ),
    );
  }
}

class _StorageWidget extends StatefulWidget {
  @override
  State<_StorageWidget> createState() => _StorageWidgetState();
}

class _StorageWidgetState extends State<_StorageWidget> {
  StorageSpace? _storageSpace;

  @override
  void initState() {
    super.initState();
    initStorageSpace();
  }

  void initStorageSpace() async {
    StorageSpace storageSpace = await getStorageSpace(
      lowOnSpaceThreshold: 2 * 1024 * 1024 * 1024,
      fractionDigits: 1,
    );

    setState(() {
      _storageSpace = storageSpace;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(
                height: 200,
                width: 200,
                child: CircularProgressIndicator(
                  strokeWidth: 20,
                  value: _storageSpace?.usageValue,
                  backgroundColor: Theme.of(context).primaryColor.withAlpha(80),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    (_storageSpace?.lowOnSpace ?? false)
                        ? Colors.red
                        : Theme.of(context).primaryColor,
                  ),
                ),
              ),
              if (_storageSpace == null) ...[
                Text(
                  '저장소 확인 중...',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              if (_storageSpace != null) ...[
                Column(
                  children: [
                    Text(
                      '${_storageSpace?.freeSize}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (_storageSpace?.lowOnSpace != true) ...[
                      Text(
                        '남았어요',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                    if (_storageSpace?.lowOnSpace == true) ...[
                      Text(
                        '공간이 부족해요!',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
          const SizedBox(height: 30),
          Text(
            _storageSpace == null
                ? ''
                : '${_storageSpace!.usedSize} / ${_storageSpace!.totalSize}',
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
