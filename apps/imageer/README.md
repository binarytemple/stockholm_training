# Imageer
Runs on [`localhost:4000`](http://localhost:4000) 

# upload endpoint 

http://localhost:4000/upload/<filename>

# uploading a file 

`curl -v -X POST  --header "Transfer-Encoding: chunked" --data-urlencode @/tmp/test.txt "http://localhost:4000/upload/foo"`

------

Example HTTP file upload application using [Raxx](https://github.com/cwrodhailer/raxx) library in Elixir.

### Usage

First you need to compile and start the service (it runs on Elixir v1.6+):

```bash
mix deps.get
iex -S mix
```

By default the server will listen on port 8080, although you can change that in `config/config.exs`
by setting `:upload.:port` configuration value.

#### Upload

Generate some sample data : 

```
seq 1 100000 | while read i ; do echo "line $1 : foo bar baz basho" >> /tmp/upload.garbage.txt ; done
```

You can upload files via curl:

```bash
curl -X PUT http://localhost:8080/uploads/garbage.txt --data-binary @/tmp/upload.garbage.txt
```

If you look at the logs in console you'll see something like this:

```
...

13:46:20.823 module=Upload.UploadService function=handle_data/2 pid=<0.374.0> [debug] Received 1460 byte chunk of data

13:46:20.824 module=Upload.UploadService function=handle_data/2 pid=<0.374.0> [debug] Received 1460 byte chunk of data

13:46:20.824 module=Upload.UploadService function=handle_data/2 pid=<0.374.0> [debug] Received 10 byte chunk of data

13:46:20.824 module=Upload.UploadService function=handle_tail/2 pid=<0.374.0> [debug] Upload completed

13:46:20.825 module=Raxx.Logger function=log_response/2 pid=<0.374.0> [info]  Sent 204 in 1670ms
```

By default uploaded files will be placed in `uploads` directory in the root of the repository. You
can change that by modifying `:upload.:uploads_dir` configuration value.

Now that a file is uploaded, go and see if it's the same as the original! I recommned uploading
pictures, e.g. [this one](https://upload.wikimedia.org/wikipedia/commons/d/dd/Big_%26_Small_Pumkins.JPG).

#### Download

You can download files by providing the same name you've used when uploading it:

```curl
curl http://localhost:8080/uploads/garbage.txt -O
```

(You'll get error 404 if the file with the given name hasn't been uploaded yet).

If you look at the logs again:

```
...
13:53:52.402 module=Upload.DownloadService function=handle_info/2 pid=<0.391.0> [debug] Sending 5000 byte chunk of data

13:53:52.402 module=Upload.DownloadService function=handle_info/2 pid=<0.391.0> [debug] Sending 5000 byte chunk of data

13:53:52.402 module=Upload.DownloadService function=handle_info/2 pid=<0.391.0> [debug] Sending 2898 byte chunk of data

13:53:52.402 module=Upload.DownloadService function=handle_info/2 pid=<0.391.0> [debug] Download completed
```

By default file is read and sent in chunks of 5000 bytes. You can change this number by modifying
`:upload.:download_chunk_size` configuration variable.


