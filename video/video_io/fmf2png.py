#!/usr/bin/python

import motmot.FlyMovieFormat.FlyMovieFormat as FMF;
import PIL.Image as Image;
import math;
import multiprocessing;
import os;
import string;
import sys;

# detect number of processors on system
def cpu_count():
   # Linux, Unix and MacOS:
   if hasattr(os, "sysconf"):
      if os.sysconf_names.has_key("SC_NPROCESSORS_ONLN"):
         # Linux & Unix:
         ncpus = os.sysconf("SC_NPROCESSORS_ONLN");
         if isinstance(ncpus, int) and ncpus > 0:
            return ncpus;
      else: 
         # OSX:
         return int(os.popen2("sysctl -n hw.ncpu")[1].read());
   # Windows:
   if os.environ.has_key("NUMBER_OF_PROCESSORS"):
      ncpus = int(os.environ["NUMBER_OF_PROCESSORS"]);
      if ncpus > 0:
         return ncpus;
   # Default
   return 1

# fmf frame reader class
class frame_reader:
   # constructor - initialize and return movie reader
   def __init__(self, filename):
      self.filename = filename;
      self.fmf      = FMF.FlyMovie(filename);
      self.n_frames = self.fmf.get_n_frames();
      self.bpp      = self.fmf.get_bits_per_pixel();

   # get the specified frame as an image
   def get_frame_image(self, n):
      # get frame
      [frame, timestamp] = self.fmf.get_frame(n);
      frame_str = frame.tostring();
      # select format
      if (self.bpp == 8):
         format = "L";
      elif (self.bpp == 24):
         format = "RGB";
      else:
         raise Exception("invalid fmf format"); 
      im = Image.fromstring( \
         format, (frame.shape[1], frame.shape[0]), frame_str);
      return im;

# fmf frame converter (png output)
class converter (multiprocessing.Process):
   # constructor
   def __init__(self, filename, use_subdirs, subdir_size, n_procs, id):
      multiprocessing.Process.__init__(self);
      # create movie reader
      self.reader = frame_reader(filename);
      # store arguments
      self.use_subdirs = use_subdirs;
      self.subdir_size = subdir_size;
      self.n_procs     = n_procs;
      self.id          = id;
      # compute output directory name
      self.outdir = string.rsplit(self.reader.filename,'.',1)[0];
      # compute subdir and frame name length
      self.name_len = max(len(str(self.reader.n_frames)),6);
      # compute # of subdirectories
      self.n_subdirs = int( \
         math.ceil(float(self.reader.n_frames) / float(subdir_size)));
      # compute frame assignment range
      f_per_proc = self.reader.n_frames / n_procs;
      f_extra    = self.reader.n_frames - (f_per_proc * n_procs);
      self.f_start = (f_per_proc * id) + min(f_extra, id);
      self.f_limit = (f_per_proc * (id+1)) + min(f_extra, id+1);
      # initialize status
      self.f_complete = multiprocessing.Value('i',0);
      self.f_total    = self.f_limit - self.f_start;

   # create output subdirectories
   def create_subdirs(self):
      # create output directory
      print "creating: " + self.outdir, "\r",
      sys.stdout.flush();
      if (not (os.path.exists(self.outdir))):
         os.mkdir(self.outdir);
      if (not (os.path.isdir(self.outdir))):
         raise Exception( \
            "cannot create directory: " + self.outdir);
      # create subdirectories (if specified)
      if (self.use_subdirs):
         # create frame subdirectory
         outdir_frames = os.path.join(self.outdir, "frames");
         print "creating: " + outdir_frames, "\r",
         if (not (os.path.exists(outdir_frames))):
            os.mkdir(outdir_frames);
         if (not (os.path.isdir(outdir_frames))):
            raise Exception( \
               "cannot create directory: " + outdir_frames);
         # create frame subdirectories
         for n in range(self.n_subdirs):
            out_subdir = os.path.join( \
               outdir_frames, str(n * self.subdir_size).zfill(self.name_len));
            if (not (os.path.exists(out_subdir))):
               os.mkdir(out_subdir);
            if (not (os.path.isdir(out_subdir))):
               raise Exception("cannot create directory: " + out_subdir);

   # convert frames in assigned range
   def run(self):
      for f in range(self.f_start, self.f_limit):
         # select subdirectory for frame
         n = f / self.subdir_size;
         outdir_frames = os.path.join(self.outdir, "frames");
         out_subdir = os.path.join( \
            outdir_frames, str(n * self.subdir_size).zfill(self.name_len));
         # assemble frame name
         f_str = str(f).zfill(self.name_len);
         if (self.use_subdirs):
            out_fname = os.path.join(out_subdir, f_str + ".png");
         else:
            out_fname = os.path.join(self.outdir, f_str + ".png");
         # read frame
         im = self.reader.get_frame_image(f);
         # write frame as png
         im.save(out_fname, "PNG");
         # update status 
         self.f_complete.value += 1;

# converter status display
class converter_status_display (multiprocessing.Process):
   # constructor
   def __init__(self, converters):
      multiprocessing.Process.__init__(self);
      # store list of converters
      self.converters = converters;
      # compute total # of frames
      self.f_complete = 0;
      self.f_total = 0;
      for c in converters:
         self.f_total += c.f_total;

   # print current status
   def print_status(self):
      # compute # of threads
      n_threads = len(self.converters);
      # compute percentage complete
      p = float(self.f_complete) / float(self.f_total);
      p_str = ("%3.0f" % (p * 100)).zfill(3);
      # compute progress strings
      f_total_str = str(self.f_total);
      f_complete_str = str(self.f_complete).zfill(len(f_total_str));
      # print status
      print n_threads, "thread(s): " + \
         f_complete_str + " / " + f_total_str + " frames " + \
         "[" + p_str + "%]" + "\r",
      sys.stdout.flush();

   # repeatedly grab and print status until done
   def run(self):
      self.print_status();
      while (self.f_complete < self.f_total):
         # recompute # complete frames
         self.f_complete = 0;
         for c in converters:
            self.f_complete += c.f_complete.value;
         # update display
         self.print_status();
      print ""

# main program
if __name__ == "__main__":
   if ((len(sys.argv) < 2) or (len(sys.argv) > 4)):
      print("Usage: fmf2png [filename] (processors) (use subdirs)");
   else:
      # get filename 
      filename = sys.argv[1];
      if (not (os.path.isfile(filename))):
         raise Exception("file not found: " + filename);
      # get number of processors to use
      if (len(sys.argv) >= 3):
         n_procs = int(sys.argv[2]);
      else: 
         n_procs = 0;
      # auto-detect number of processors if zero specified
      if (n_procs < 1):
         n_procs = cpu_count();
      # set subdirectory size
      if (len(sys.argv) >= 4):
         use_subdirs = int(sys.argv[3]);
      else:
         use_subdirs = 0;
      subdir_size = 1000;
      # create converters
      converters = [];
      for n in range(n_procs):
         c = converter(filename, use_subdirs, subdir_size, n_procs, n);
         converters.append(c);
      # display command summary
      print "fmf2png: " + filename + " -> " + converters[0].outdir;
      # create output directories
      converters[0].create_subdirs();
      # create status display
      s = converter_status_display(converters);
      s.start();
      # convert frames
      for c in converters:
         c.start();
      # join all subprocesses
      for c in converters:
         c.join();
      s.join();
