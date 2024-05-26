# A makefile to transfer data from GCS to mdx object storage (S3 compatible)

STATS_INTERVAL := 1m
RCLONE_GLOBAL_FLAGS := -v --config=rclone.conf --stats=${STATS_INTERVAL}
RCLONE_COPY_FLAGS := --checksum

SRC_BUCKET_NON_LUSTRE := gcs:llama-2-172b-checkpoints
SRC_BUCKET := gcs:llama-2-172b-lustre-checkpoints
DEST_BUCKET := mdx-s3:llama-2-172b-checkpoints

begin_non_lustre := 500
end_non_lustre := 12500
begin_lustre := 13000
end_10percent := 30000
begin_50percent := 31000
end_50percent := 150000

_checkpoints_non_lustre = $(shell seq -f 'stamps/iter_%07g' $(begin_non_lustre) 500 $(end_non_lustre))
_checkpoints_10percent = $(shell seq -f 'stamps/iter_%07g' $(begin_lustre) 500 $(end_10percent))
_checkpoints_50percent = $(shell seq -f 'stamps/iter_%07g' $(begin_50percent) 1000 $(end_50percent))

# Default is dry run mode
dry_run := 1

# Dry run mode
TOUCH_FLAGS =
ifeq ($(dry_run),1)
	RCLONE_GLOBAL_FLAGS += --dry-run
	TOUCH_FLAGS += --no-create
endif

# Watch flags
WATCH_FLAGS :=
ifdef SLACK_WEBHOOK
	WATCH_FLAGS += --slack_webhook ${SLACK_WEBHOOK}
endif

# Targets
.DEFAULT_GOAL = all
.PHONY: checkpoints_non_lustre checkpoints_10percent checkpoints_50percent

checkpoints_non_lustre : $(_checkpoints_non_lustre)
checkpoints_10percent : $(_checkpoints_10percent)
checkpoints_50percent : $(_checkpoints_50percent)

all : $(checkpoints_non_lustre) $(checkpoints_10percent) $(checkpoints_50percent)

$(_checkpoints_non_lustre) : stamps/% : stamps logs
	./watch.py ${WATCH_FLAGS} \
		rclone ${RCLONE_GLOBAL_FLAGS} copy \
		${RCLONE_COPY_FLAGS} \
		--log-file=logs/$*.log \
		${SRC_BUCKET_NON_LUSTRE}/$*/ ${DEST_BUCKET}/$* && \
	touch $(TOUCH_FLAGS) $@

$(_checkpoints_10percent) : stamps/% : stamps logs
	./watch.py ${WATCH_FLAGS} \
		rclone ${RCLONE_GLOBAL_FLAGS} copy \
		${RCLONE_COPY_FLAGS} \
		--log-file=logs/$*.log \
		${SRC_BUCKET}/$*/ ${DEST_BUCKET}/$* && \
	touch $(TOUCH_FLAGS) $@

$(_checkpoints_50percent) : stamps/% : stamps logs
	./watch.py ${WATCH_FLAGS} \
		rclone ${RCLONE_GLOBAL_FLAGS} copy \
		${RCLONE_COPY_FLAGS} \
		--log-file=logs/$*.log \
		${SRC_BUCKET}/$*/ ${DEST_BUCKET}/$* && \
	touch $(TOUCH_FLAGS) $@

logs:
	mkdir -p $@

stamps:
	mkdir -p $@
